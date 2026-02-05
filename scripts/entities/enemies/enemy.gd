extends CharacterBody2D
class_name Enemy


# Node Imports

# Visuals
@onready var animation_player: AnimationPlayer = $visuals/AnimationPlayer
@onready var lifebar: ProgressBar = $visuals/lifebar
@onready var phantom_camera: PhantomCamera2D = $camera/PhantomCamera2D
@onready var posess_cooldown_bar: ProgressBar = $visuals/posess_cooldown_bar
@onready var posessed_particles: GPUParticles2D = $visuals/posessed_particles
@onready var shockwave_animation: AnimationPlayer = $visuals/shockwave_animation

# Timer
@onready var drain_life_timer: Timer = $timer/drain_life_timer
@onready var posess_cooldown_timer: Timer = $timer/posess_cooldown_timer
@onready var delete_node_timer: Timer = $timer/delete_node_timer
@onready var wander_timer: Timer = $timer/wander_timer
@onready var follow_scream_timer: Timer = $timer/follow_scream_timer

# Audio
@onready var enter_posession_sound: AudioStreamPlayer2D = $audio/enter_posession_sound
@onready var walking_sound: AudioStreamPlayer2D = $audio/walking_sound
@onready var dying_sound: AudioStreamPlayer2D = $audio/dying_sound
@onready var ghost_death_sound: AudioStreamPlayer2D = $audio/ghost_death_sound


# Navigation
@onready var navigation_agent_2d: NavigationAgent2D = $navigation/Marker2D/NavigationAgent2D

# Vision Cone
@onready var vision_cone: VisionCone2D = $cones/VisionCone2D
@onready var vision_cone_area: Area2D = $cones/VisionCone2D/VisionConeArea
@onready var vision_cone_collider: CollisionPolygon2D = $cones/VisionCone2D/VisionConeArea/VisionConeCollider


# Hitbox
@onready var enemy_hitbox: Area2D = $hitbox/enemy_hitbox
@onready var hitbox_shape: CollisionShape2D = $hitbox/enemy_hitbox/CollisionShape2D
@onready var interest_area: Area2D = $hitbox/interest_area
@onready var interest_area_shape: CollisionShape2D = $hitbox/interest_area/interest_area_shape
@onready var interact_area: Area2D = $hitbox/interact_area
@onready var interact_area_shape: CollisionShape2D = $hitbox/interact_area/interact_area_shape


# Raycasts
@onready var wall_raycast: RayCast2D = $raycasts/wall_raycast
@onready var wall_raycast_2: RayCast2D = $raycasts/wall_raycast2


# Variables
@onready var is_posessed := false
@onready var can_be_posessed := true
@export var posess_cooldown_time := 3.0

# Movement
@export var running_speed := 35.0
@export var life_time := 5.0
@onready var is_dead := false

# Wandering / Patrolling
@export var wander_speed: float = 40.0
@export var min_wander_time: float = 1.0
@export var max_wander_time: float = 3.0
@onready var is_interested := false
@onready var interest_target_position: Vector2 = Vector2.ZERO
@onready var following_scream := false


func _ready():
	drain_life_timer.wait_time = life_time
	lifebar.max_value = drain_life_timer.wait_time
	lifebar.value = drain_life_timer.wait_time
	posess_cooldown_timer.wait_time = posess_cooldown_time
	posess_cooldown_bar.max_value = posess_cooldown_timer.wait_time
func _physics_process(delta: float) -> void:
	
	
	if Input.is_action_just_pressed("exit_enemy") and is_posessed:
		exit_posession()
	
	posess_cooldown_bar.value = posess_cooldown_timer.time_left
	lifebar.value = drain_life_timer.time_left
	
	if Globals.game_over:
		lifebar.visible = false
	
	# Debug
	#print(lifebar.value)
	
	
	move_and_slide()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			enter_posession()
			
			
			
			
func enter_posession():
	if can_be_posessed and not Globals.player_posessing:
		Globals.enter_enemy.emit()
		Globals.player_posessing = true
		is_posessed = true
		lifebar.visible = true
		vision_cone_collider.disabled = true
		set_collision_mask_value(6, false)
		interest_area_shape.disabled = false
		enter_posession_sound.play()
		shockwave_animation.play("enter")
		posessed_particles.emitting = true
		interact_area_shape.disabled = false
		if drain_life_timer.time_left == 0.0 and not is_dead:
			drain_life_timer.start()
		else:
			drain_life_timer.paused = false
			
			
			


func _on_posess_cooldown_timer_timeout() -> void:
	can_be_posessed = true
	posess_cooldown_bar.visible = false
	
func exit_posession():
	Globals.exit_enemy.emit()
	Globals.player_posessing = false
	is_posessed = false
	lifebar.visible = false
	can_be_posessed = false
	interest_area_shape.disabled = true
	enter_posession_sound.play()
	shockwave_animation.play("exit")
	posessed_particles.emitting = false
	interact_area_shape.disabled = true
	if not is_dead:
		posess_cooldown_timer.start()
		drain_life_timer.paused = true
		posess_cooldown_bar.visible = true
		vision_cone_collider.disabled = false
		set_collision_mask_value(6, true)

func _on_drain_life_timer_timeout() -> void:
	if not Globals.game_over:
		is_dead = true


func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("trap"):
		subtract_time(3.0)
	if area.is_in_group("chandelier"):
		subtract_time(10.0)
	
	if area.is_in_group("interest_area") and is_posessed:
		is_interested = true
	
	if area.is_in_group("radar"):
		print("radar")
		can_be_posessed = false
		
	if area.is_in_group("scream_area"):
		interest_target_position = area.global_position
		following_scream = true
	
	
	var cone_owner = area.get_parent().get_parent()
	if cone_owner == self:
		return
	elif is_posessed and area.is_in_group("vision_cone"):
		Globals.game_over = true
		ghost_death_sound.playing = true
		
	
		
func _on_enemy_hitbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("interest_area"):
		is_interested = false
	if area.is_in_group("radar"):
		can_be_posessed = true
		
func subtract_time(amount: float):
	var new_time = drain_life_timer.time_left - amount

	if new_time <= 0:
		# Falls die Zeit abgelaufen ist, stoppen und Timeout auslösen
		drain_life_timer.stop()
		_on_drain_life_timer_timeout() 
	else:
		# Timer mit der verbleibenden Zeit neu starten
		drain_life_timer.start(new_time)

func get_bounce_direction() -> Vector2:
	if get_slide_collision_count() > 0:
		var collision = get_last_slide_collision()
		return collision.get_normal()
	return Vector2.ZERO
