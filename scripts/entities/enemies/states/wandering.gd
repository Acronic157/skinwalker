extends EnemyState
class_name EnemyWandering

@export var enemy: CharacterBody2D
@onready var animation: Sprite2D = $"../../visuals/animation"



var wander_direction: Vector2 = Vector2.ZERO
var wander_timer: float = 0.0

# NEU: Ein kleiner Timer, der verhindert, dass wir sofort wieder abprallen
var wall_collision_cooldown: float = 0.0 



func Enter():
	enemy.animation_player.play("idle")
	pick_new_direction()
	enemy.hitbox_shape.disabled = false

func Exit():
	pass

func Update(_delta: float):
	pass

func Physics_Update(delta: float):
	# Timer runterzählen
	wander_timer -= delta
	wall_collision_cooldown -= delta
	
	# --- LOGIK CHANGE: ---
	# Wir prüfen Kollisionen NUR, wenn der Cooldown abgelaufen ist.
	# Das gibt dem Gegner Zeit, aus der Ecke rauszukommen.
	var hit_wall = false
	if wall_collision_cooldown <= 0:
		if enemy.is_on_wall() or enemy.wall_raycast.is_colliding() or enemy.wall_raycast_2.is_colliding():
			hit_wall = true
	
	# Richtung wechseln, wenn Zeit um ist ODER wir eine Wand (mit Cooldown) treffen
	if wander_timer <= 0 or hit_wall:
		pick_new_direction()
		# Wenn es ein Wand-Treffer war, setzen wir den Cooldown (z.B. 0.2 Sekunden)
		if hit_wall:
			wall_collision_cooldown = 0.2
	
	# Bewegung anwenden (Sanftes Beschleunigen)
	var target_velocity = wander_direction * enemy.wander_speed
	enemy.velocity = enemy.velocity.move_toward(target_velocity, 8.0) # Wert leicht erhöht für schnelleres Reagieren
	
	# Animation
	if wander_direction != Vector2.ZERO:
		if abs(wander_direction.x) > abs(wander_direction.y):
			if wander_direction.x > 0:
				enemy.animation_player.play("right")
				animation.flip_h = false
			else:
				enemy.animation_player.play("right")
				animation.flip_h = true
		else:
			if wander_direction.y > 0:
				enemy.animation_player.play("down")
			else:
				enemy.animation_player.play("up")
	else:
		enemy.animation_player.play("idle")
	
	# --- VISION CONE FIX ---
	if wander_direction != Vector2.ZERO:
		# ACHTUNG: Godot nutzt Radianten. 300 wäre fast 50 Umdrehungen.
		# Ich nehme an, du meinst 300 Grad Offset? Nutze deg_to_rad()!
		var offset_radians = deg_to_rad(-80) 
		var target_angle = wander_direction.angle() + offset_radians
		
		# Langsameres Drehen: Faktor von 10.0 auf 2.0 oder 3.0 reduziert
		enemy.vision_cone.rotation = lerp_angle(enemy.vision_cone.rotation, target_angle, delta * 2.5)
	
	# State Transitions
	if enemy.is_dead:
		EnemyTransitioned.emit(self, "dying")
	if enemy.is_posessed and not enemy.is_dead:
		EnemyTransitioned.emit(self, "posessed")
	if not enemy.is_dead and enemy.following_scream:
		EnemyTransitioned.emit(self, "follow_scream")

func pick_new_direction():
	# 1. Priorität: Wände vermeiden
	# Wir prüfen hier NICHT auf Cooldown, da wir ja gerade entschieden haben,
	# dass wir eine neue Richtung brauchen.
	if enemy.is_on_wall() or enemy.wall_raycast.is_colliding() or enemy.wall_raycast_2.is_colliding():
		
		var wall_normal = enemy.get_bounce_direction()
		
		# Fallback falls get_bounce_direction 0 liefert (z.B. bei Raycast-Treffer statt Körper-Treffer)
		if wall_normal == Vector2.ZERO:
			# Wenn Raycast 1 trifft, drehen wir uns weg
			if enemy.wall_raycast.is_colliding():
				wall_normal = (enemy.global_position - enemy.wall_raycast.get_collision_point()).normalized()
			# Wenn Raycast 2 trifft
			elif enemy.wall_raycast_2.is_colliding():
				wall_normal = (enemy.global_position - enemy.wall_raycast_2.get_collision_point()).normalized()
			# Notfall
			else:
				wall_normal = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		
		# "Cone" Bouncing: Wir addieren Zufall, bleiben aber grob in der "Weg von Wand"-Richtung
		var random_bounce = wall_normal + Vector2(randf_range(-0.6, 0.6), randf_range(-0.6, 0.6))
		wander_direction = random_bounce.normalized()
		
		# Impuls geben (Damit er sofort Fahrt aufnimmt)
		enemy.velocity = wander_direction * enemy.wander_speed
		
	# 2. Priorität: Interesse
	elif enemy.is_interested:
		var target_dir = (enemy.interest_target_position - enemy.global_position).normalized()
		var rx = randf_range(-0.2, 0.2)
		var ry = randf_range(-0.2, 0.2)
		wander_direction = (target_dir + Vector2(rx, ry)).normalized()
		
	# 3. Priorität: Zufall
	else:
		var rx = randf_range(-1.0, 1.0)
		var ry = randf_range(-1.0, 1.0)
		wander_direction = Vector2(rx, ry).normalized()
	
	# Timer
	wander_timer = randf_range(enemy.min_wander_time, enemy.max_wander_time)
