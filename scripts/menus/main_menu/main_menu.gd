extends Control

@export var level: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Levelmanager.current_level = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	play()



func play():
	Levelmanager.current_level += 1
	Levelmanager._unlock_level(Levelmanager.current_level)
	var level_to_load: String = Levelmanager._load_level(Levelmanager.current_level)
	if level_to_load == "":
		return
	get_tree().call_deferred("change_scene_to_file", level_to_load)
