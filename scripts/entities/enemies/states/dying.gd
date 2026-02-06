extends EnemyState
class_name EnemyDying

@export var enemy: CharacterBody2D

func Enter():
	enemy.animation_player.play("dying")
	enemy.set_collision_mask_value(6, false)
	enemy.dying_sound.playing = true
	enemy.delete_node_timer.start()
	if enemy.is_posessed:
		enemy.exit_posession()
	enemy.vision_cone_area.monitoring = false
	enemy.vision_cone_area.monitorable = false
	enemy.vision_cone_collider.disabled = true
	Globals.player_health += 10
func Exit():
	pass

func Update(_delta: float):
	pass
	

func Physics_Update(delta: float):
	# Stop the enemy from moving when dead
	enemy.velocity.x = 0.0
	enemy.velocity.y = 0.0
	
	
	
	
	






func _on_delete_node_timer_timeout() -> void:
	# Delete Node
	if is_instance_valid(enemy):
		enemy.queue_free()
