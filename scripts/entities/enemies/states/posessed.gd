extends EnemyState
class_name EnemyPosessed

@export var enemy: CharacterBody2D


@onready var vision_cone_collider: CollisionPolygon2D = $"../../cones/screaming_cone/screaming_cone_area/VisionConeCollider"
@onready var screaming_cone: VisionCone2D = $"../../cones/screaming_cone"
@onready var point_light_2d: PointLight2D = $"../../visuals/PointLight2D"
@onready var light_occluder_2d: LightOccluder2D = $"../../visuals/LightOccluder2D"
@onready var animation: Sprite2D = $"../../visuals/animation"


func Enter():
	enemy.animation_player.play("idle")
	enemy.phantom_camera.priority = 2
	enemy.vision_cone.visible = false
	vision_cone_collider.disabled = false
	point_light_2d.visible = true
	light_occluder_2d.visible = false

	
func Exit():
	enemy.phantom_camera.priority = 0
	enemy.walking_sound.playing = false
	vision_cone_collider.disabled = true
	point_light_2d.visible = false
	light_occluder_2d.visible = true
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
				animation.flip_h = false
			else:
				enemy.animation_player.play("right")
				animation.flip_h = true
		else:
			if direction.y > 0:
				enemy.animation_player.play("down")
			else:
				enemy.animation_player.play("up")
				
		enemy.velocity = direction * enemy.running_speed
		
	else:
		enemy.velocity = enemy.velocity.move_toward(Vector2.ZERO, enemy.running_speed)
		enemy.walking_sound.playing = false
		enemy.animation_player.play("idle")
			
	# State Transitions
	if enemy.is_dead:
		EnemyTransitioned.emit(self, "dying")
	if not enemy.is_posessed or Globals.game_over:
		EnemyTransitioned.emit(self, "wandering")
