extends EnemyState
class_name EnemyPosessed

@export var enemy: CharacterBody2D


@onready var vision_cone_collider: CollisionPolygon2D = $"../../cones/screaming_cone/screaming_cone_area/VisionConeCollider"


func Enter():
	enemy.animation_player.play("idle")
	enemy.phantom_camera.priority = 2
	enemy.vision_cone.visible = false
	#vision_cone_collider.disabled = false

	
func Exit():
	enemy.phantom_camera.priority = 0
	enemy.walking_sound.playing = false
	#vision_cone_collider.disabled = false
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
		if not enemy.walking_sound.playing:
			enemy.walking_sound.playing = true
		enemy.velocity = direction * enemy.running_speed
	
		# Animation
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				enemy.animation_player.play("right")
			else:
				enemy.animation_player.play("left")
		else:
			if direction.y > 0:
				enemy.animation_player.play("down")
			else:
				enemy.animation_player.play("up")
				
		enemy.velocity = direction * enemy.running_speed
		
	else:
		# Sanftes Abbremsen, wenn keine Taste gedrückt wird
		enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.running_speed)
		enemy.walking_sound.playing = false
		enemy.animation_player.play("idle")
			
	# State Transitions
	if enemy.is_dead:
		EnemyTransitioned.emit(self, "dying")
	if not enemy.is_posessed or Globals.game_over:
		EnemyTransitioned.emit(self, "screaming")
