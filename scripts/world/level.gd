extends Node2D

@export var main_menu: PackedScene
@onready var game_over: Control = $ui/CanvasLayer/GameOver
@onready var animation_player: AnimationPlayer = $ui/AnimationPlayer
@onready var player_life_bar: ProgressBar = $ui/CanvasLayer/player_life_bar
@onready var player_life_timer: Timer = $ui/CanvasLayer/player_life_bar/player_life_timer
@onready var next_level_menu: Control = $ui/CanvasLayer/next_level_menu
@onready var ghost_death_sound_no_gun: AudioStreamPlayer2D = $audio/ghost_death_sound_no_gun
@onready var pause_menu: Control = $ui/CanvasLayer/pause_menu
@onready var game_over_sound: AudioStreamPlayer2D = $audio/game_over_sound

@onready var player_first_posession := false

var health_tween: Tween

var played_once := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	Globals.restart_level.connect(_on_restart_level)
	Globals.enter_main_menu.connect(_on_enter_main_menu)
	Globals.level_completed = false
	Globals.next_level.connect(_enter_next_level)
	
	player_life_bar.max_value = Globals.player_max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Game Over Mechanic
	if Globals.game_over:
		game_over.visible = true
		if not game_over_sound.playing:
			game_over_sound.playing = true
	else:
		game_over.visible = false
		get_tree().paused = false
	
	
	# Lifebar Mechanic
	if Globals.player_posessing:
		player_life_timer.stop()
		#player_first_posession = true
	
	elif not Globals.player_posessing and player_life_timer.time_left == 0.0:
		player_life_timer.start()

	if player_life_bar.value != Globals.player_health:
		update_bar_smooth()
	
	if Globals.player_health <= 0:
		Globals.game_over = true
		if not ghost_death_sound_no_gun.playing and not played_once:
			played_once = true
			ghost_death_sound_no_gun.playing = true
	
	var enemies = get_tree().get_nodes_in_group("enemies").size()
	if enemies == 0:
		next_level_menu.visible = true
		Globals.level_completed = true

		# Pause Menu
	if Input.is_action_just_pressed("pause_menu"):
		Globals.game_paused = !Globals.game_paused
	if Globals.game_paused:
		Globals.game_paused = true
		get_tree().paused = true
		pause_menu.visible = true
	if not Globals.game_paused:
		Globals.game_paused = false
		get_tree().paused = false
		pause_menu.visible = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "enter_level":
		get_tree().paused = false
		Globals.current_level += 1
		game_over.visible = false
	
	if anim_name == "enter_main_menu":
		get_tree().paused = false
		_enter_main_menu()
	
	if anim_name == "restart_level":
		get_tree().paused = false
		_restart_level()
	
		
func _on_restart_level():
	game_over.visible = false
	Globals.game_over = false
	reset_variables()
	animation_player.play("restart_level")
	
func _restart_level():
	Globals.game_over = false
	get_tree().call_deferred("reload_current_scene")
	reset_variables()
	
func _on_enter_main_menu():
	#get_tree().paused = true
	animation_player.play("enter_main_menu")

func _enter_main_menu():
	get_tree().call_deferred("change_scene_to_file", "res://scenes/menus/main_menu.tscn")
	Levelmanager.current_level = 1
	reset_variables()
	
func reset_variables():
	get_tree().paused = false
	player_first_posession = false
	Globals.level_completed = false
	Globals.game_over = false
	Globals.player_posessing = false
	Globals.game_paused = false
	Globals.player_health = 100
	game_over_sound.playing = false
	player_life_bar.max_value = player_life_timer.wait_time
	player_life_timer.stop()

func _on_level_complete():
	_enter_next_level()
	Globals.game_paused = true
	get_tree().paused = true
	
func _enter_next_level():
	Levelmanager.current_level += 1
	Levelmanager._unlock_level(Levelmanager.current_level)
	var level_to_load: String = Levelmanager._load_level(Levelmanager.current_level)
	if level_to_load == "":
		return
	get_tree().call_deferred("change_scene_to_file", level_to_load)
	reset_variables()

func _on_player_life_timer_timeout() -> void:
	if not Globals.level_completed:
		Globals.player_health -= 10.0
		player_life_timer.start()
	
func update_bar_smooth():
	if health_tween:
		health_tween.kill()
	health_tween = create_tween()
	health_tween.tween_property(player_life_bar, "value", Globals.player_health, 0.25)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
