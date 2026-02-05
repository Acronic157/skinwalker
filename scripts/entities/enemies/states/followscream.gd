extends EnemyState
class_name EnemyFollowScream

@export var enemy: CharacterBody2D
@onready var follow_scream_timer: Timer = $"../../timer/follow_scream_timer"

func Enter():
	enemy.navigation_agent_2d.target_position = enemy.interest_target_position
	follow_scream_timer.start()
	enemy.set_collision_mask_value(6, false)
	enemy.interact_area_shape.disabled = false

	
func Exit():
	follow_scream_timer.stop()
	enemy.following_scream = false
	if not enemy.is_posessed:
		enemy.set_collision_mask_value(6, true)
	enemy.interact_area_shape.disabled = true

func Update(_delta: float):
	pass

func Physics_Update(delta: float):
	if enemy.is_dead:
		EnemyTransitioned.emit(self, "dying")
		return
	if enemy.is_posessed:
		EnemyTransitioned.emit(self, "posessed")
		return

	if enemy.navigation_agent_2d.is_navigation_finished():
		EnemyTransitioned.emit(self, "wandering")
		return

	var current_pos = enemy.global_position
	var next_path_pos = enemy.navigation_agent_2d.get_next_path_position()
	
	var direction = (next_path_pos - current_pos).normalized()
	var target_velocity = direction * enemy.wander_speed
	
	enemy.velocity = enemy.velocity.move_toward(target_velocity, 10.0)
	
	if direction != Vector2.ZERO:
		var target_angle = direction.angle() + deg_to_rad(300)
		enemy.vision_cone.rotation = lerp_angle(enemy.vision_cone.rotation, target_angle, delta * 5.0)
	
	update_animation(direction)

func update_animation(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			enemy.animation_player.play("right")
		else:
			enemy.animation_player.play("left")
	else:
		if dir.y > 0:
			enemy.animation_player.play("down")
		else:
			enemy.animation_player.play("up")

func _on_follow_scream_timer_timeout() -> void:
	EnemyTransitioned.emit(self, "wandering")
