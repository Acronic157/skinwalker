extends EnemyState
class_name EnemyBoilerplate

@export var enemy: CharacterBody2D

func Enter():
	enemy.animation_player.play("idle")
	
func Exit():
	pass

func Update(_delta: float):
	pass
	

func Physics_Update(delta: float):
	
	
	
	
	# State Transitions
	if enemy.is_dead:
		EnemyTransitioned.emit(self, "dying")
	if enemy.is_posessed:
		EnemyTransitioned.emit(self, "posessed")
