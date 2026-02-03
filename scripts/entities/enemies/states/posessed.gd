extends EnemyState
class_name EnemyPosessed

@export var enemy: CharacterBody2D

func Enter():
	enemy.animation_player.play("idle")
	enemy.phantom_camera.priority = 2
	enemy.vision_cone.visible = false

	
func Exit():
	enemy.phantom_camera.priority = 0
	if not enemy.is_dead:
		enemy.vision_cone.visible = true



func Update(_delta: float):
	pass
	

func Physics_Update(delta: float):
	
	# Movement
	# 1. Input-Richtung für beide Achsen (X und Y) abfragen
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")

	# 2. Geschwindigkeit basierend auf der Richtung setzen
	if direction != Vector2.ZERO:
		enemy.velocity = direction * enemy.running_speed
	else:
		# Sanftes Abbremsen, wenn keine Taste gedrückt wird
		enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.running_speed)


	
	# State Transitions
	if enemy.is_dead:
		EnemyTransitioned.emit(self, "dying")
	if not enemy.is_posessed or Globals.game_over:
		EnemyTransitioned.emit(self, "wandering")
