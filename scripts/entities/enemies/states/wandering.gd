extends EnemyState
class_name EnemyWandering

@export var enemy: CharacterBody2D

var wander_direction: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0

func Enter():
	enemy.animation_player.play("idle")
	pick_new_direction()

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(delta: float):
	# Timer runterzählen
	wander_timer -= delta
	
	# Richtung wechseln, wenn Zeit um ist oder eine Wand im Weg steht
	if wander_timer <= 0 or enemy.is_on_wall() or enemy.wall_raycast.is_colliding() or enemy.wall_raycast_2.is_colliding():
		pick_new_direction()
	
	# Bewegung anwenden
	enemy.velocity = wander_direction * enemy.wander_speed
	enemy.move_and_slide()
	
	# Vision Cone drehen
	if wander_direction != Vector2.ZERO:
		var target_angle = wander_direction.angle() + 300
		# Weiches Drehen mit lerp_angle (10.0 ist die Geschwindigkeit der Drehung)
		enemy.vision_cone.rotation = lerp_angle(enemy.vision_cone.rotation, target_angle, delta * 10.0)
	
	# State Transitions
	if enemy.is_dead:
		EnemyTransitioned.emit(self, "dying")
	if enemy.is_posessed:
		EnemyTransitioned.emit(self, "posessed")

func pick_new_direction():
	var random_dir: Vector2
	var target_dir: Vector2
	
	# --- Zufallsrichtung ---
	var rx = randf_range(-1.0, 1.0)
	var ry = randf_range(-1.0, 1.0)
	random_dir = Vector2(rx, ry).normalized()
	
	# --- Wenn interessiert → Richtung zum Ziel berechnen ---
	if enemy.is_interested:
		target_dir = (enemy.interest_target_position - enemy.global_position).normalized()
		
		# Gewichtung (0.0 = ignorieren, 1.0 = volle Verfolgung)
		var interest_strength = 0.65
		
		# Mischung aus Zufall und Ziel
		wander_direction = (random_dir * (1.0 - interest_strength) + target_dir * interest_strength).normalized()
	else:
		wander_direction = random_dir
	
	# --- Zeit bis neue Richtungswahl ---
	wander_timer = randf_range(enemy.min_wander_time, enemy.max_wander_time)
