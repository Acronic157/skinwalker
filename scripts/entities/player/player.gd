extends Node2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var ghost: Sprite2D = $ghost
@export var ghost_speed := 1.0
@export var offset: Vector2 = Vector2(70, 70)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gpu_particles_2d.visible = true
	ghost.visible = true
	visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gpu_particles_2d.global_position = get_global_mouse_position()
	visible = !Globals.player_posessing
	gpu_particles_2d.emitting = !Globals.player_posessing
	
	
	# Ghost following mouse
	var target_pos = get_global_mouse_position() + offset
	ghost.global_position = ghost.global_position.lerp(target_pos, ghost_speed * delta)
