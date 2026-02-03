extends EnemyState
class_name EnemyDying

@export var enemy: CharacterBody2D

func Enter():
	enemy.animation_player.play("idle")
	enemy.delete_node_timer.start()
	enemy.exit_posession()
	enemy.vision_cone_area.monitoring = false
	enemy.vision_cone_area.monitorable = false
	enemy.vision_cone_collider.disabled = true
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
