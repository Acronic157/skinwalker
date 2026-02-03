extends Node2D

@export var main_menu: PackedScene
@onready var game_over: Control = $ui/CanvasLayer/GameOver
@onready var animation_player: AnimationPlayer = $ui/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	game_over.restart_level.connect(_on_restart_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Game Over Mechanic
	if Globals.game_over:
		game_over.visible = true
		#get_tree().paused = true






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
	get_tree().paused = true
	game_over.visible = false
	animation_player.play("restart_level")
	
func _restart_level():
	Globals.game_over = false
	get_tree().call_deferred("reload_current_scene")
	
func _on_enter_main_menu():
	get_tree().paused = true
	animation_player.play("exit_level")

func _enter_main_menu():
	get_tree().change_scene_to_file(str(main_menu))
