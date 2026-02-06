extends Node2D

@export var dialogue_resource: DialogueResource
# then
@export var dialogue_start: String = "start"

const Balloon = preload("res://dialogues/ballons/balloon.tscn")


# or
#var dialogue_line = await resource.get_next_dialogue_line("start")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child.call_deferred(balloon)
	balloon.call_deferred("start", dialogue_resource, dialogue_start)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dialogue_ended(ressource) -> void:
	Levelmanager.current_level += 1
	Levelmanager._unlock_level(Levelmanager.current_level)
	var level_to_load: String = Levelmanager._load_level(Levelmanager.current_level)
	if level_to_load == "":
		return
	get_tree().call_deferred("change_scene_to_file", level_to_load)
