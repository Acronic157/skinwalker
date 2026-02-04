extends EnemyState
class_name EnemyScreaming

@export var enemy: CharacterBody2D
@onready var scream_duration_timer: Timer = $"../../timer/scream_duration_timer"

@onready var vision_cone_collider: CollisionPolygon2D = $"../../cones/screaming_cone/screaming_cone_area/VisionConeCollider"

func Enter():
	enemy.animation_player.play("idle")
	scream_duration_timer.start()
	#enemy.shockwave_animation.play("scream")
	vision_cone_collider.disabled = false
	
func Exit():
	#enemy.shockwave_animation.stop()
	#enemy.shockwave_animation.play("RESET")
	vision_cone_collider.disabled = true

func Update(_delta: float):
	pass
	

func Physics_Update(delta: float):
	
	enemy.velocity.x = 0
	enemy.velocity.y = 0
	
	


func _on_scream_duration_timer_timeout() -> void:
	# State Transitions
	if enemy.is_dead:
		EnemyTransitioned.emit(self, "dying")
	else:
		EnemyTransitioned.emit(self, "wandering")
