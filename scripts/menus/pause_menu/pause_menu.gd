extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	Globals.game_paused = false
	get_tree().paused = false

func _on_restart_level_pressed() -> void:
	Globals.restart_level.emit()
	get_tree().call_deferred("reload_current_scene")


func _on_main_menu_pressed() -> void:
	Globals.enter_main_menu.emit()
