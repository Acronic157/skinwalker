extends Node2D

@onready var mouse_trail: GPUParticles2D = $mouse_trail
@onready var white_trail: GPUParticles2D = $ghost/white_trail


@onready var ghost: Sprite2D = $ghost
@export var ghost_speed := 1.0
@export var offset: Vector2 = Vector2(70, 70)
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var local_player_posessing := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Signals
	Globals.enter_enemy.connect(_on_enter_enemy)
	Globals.exit_enemy.connect(_on_exit_enemy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	mouse_trail.global_position = get_global_mouse_position()

	# Ghost following mouse
	var target_pos = get_global_mouse_position() + offset
	var old_pos = ghost.global_position
	ghost.global_position = ghost.global_position.lerp(target_pos, ghost_speed * delta)
	var movement_vector = ghost.global_position - old_pos
	update_ghost_animation(movement_vector)


func _on_enter_enemy():
	animation_player.play("enter")
	local_player_posessing = true



func _on_exit_enemy():
	animation_player.play("exit")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "enter":
		mouse_trail.emitting = false
		white_trail.emitting = false
	elif anim_name == "exit":
		local_player_posessing = false
		mouse_trail.emitting = true
		white_trail.emitting = true
	
func update_ghost_animation(dir: Vector2):
	if local_player_posessing:
		return
	if dir.length() > 0.1:
		if abs(dir.x) > abs(dir.y) * 1.4:
			if dir.x > 0:
				animation_player.play("right")
			else:
				animation_player.play("left")
		else:
			if dir.y > 0:
				animation_player.play("down")
			else:
				animation_player.play("up")
	else:
		if animation_player.has_animation("idle"):
				animation_player.play("idle")
