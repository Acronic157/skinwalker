extends CharacterBody2D
class_name Enemy


# Node Imports

# Visuals
@onready var animation_player: AnimationPlayer = $visuals/AnimationPlayer
@onready var lifebar: ProgressBar = $visuals/lifebar
@onready var phantom_camera: PhantomCamera2D = $camera/PhantomCamera2D
@onready var posess_cooldown_bar: ProgressBar = $visuals/posess_cooldown_bar

# Timer
@onready var drain_life_timer: Timer = $timer/drain_life_timer
@onready var posess_cooldown_timer: Timer = $timer/posess_cooldown_timer
@onready var delete_node_timer: Timer = $timer/delete_node_timer
@onready var wander_timer: Timer = $timer/wander_timer


# Navigation

# Vision Cone
@onready var vision_cone: VisionCone2D = $cones/VisionCone2D


# Hitbox
@onready var enemy_hitbox: Area2D = $hitbox/enemy_hitbox


# Raycasts
@onready var wall_raycast: RayCast2D = $raycasts/wall_raycast
@onready var wall_raycast_2: RayCast2D = $raycasts/wall_raycast2


# Variables
@onready var is_posessed := false
@onready var can_be_posessed := true
@export var posess_cooldown_time := 3.0

# Movement
@export var running_speed := 150.0
@export var life_time := 5.0
@onready var is_dead := false

# Wandering / Patrolling
@export var wander_speed: float = 30.0
@export var min_wander_time: float = 1.0
@export var max_wander_time: float = 3.0


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
	
	
	# Debug
	#print(lifebar.value)
	
	
	move_and_slide()


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			on_click_action()
			
			
			
			
func on_click_action():
	if can_be_posessed and not Globals.player_posessing:
		Globals.player_posessing = true
		is_posessed = true
		lifebar.visible = true
		
		if drain_life_timer.time_left == 0.0 and not is_dead:
			drain_life_timer.start()
		else:
			drain_life_timer.paused = false
			
			
			


func _on_posess_cooldown_timer_timeout() -> void:
	can_be_posessed = true
	posess_cooldown_bar.visible = false
	
func exit_posession():
	Globals.player_posessing = false
	is_posessed = false
	lifebar.visible = false
	can_be_posessed = false
	if not is_dead:
		posess_cooldown_timer.start()
		drain_life_timer.paused = true
		posess_cooldown_bar.visible = true

func _on_drain_life_timer_timeout() -> void:
	is_dead = true


func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	if is_posessed:
		Globals.game_over = true
