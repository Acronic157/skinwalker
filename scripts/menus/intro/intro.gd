extends Node2D

@export var resource: DialogueResource
# then
var dialogue_line = await DialogueManager.get_next_dialogue_line(resource, "start")
# or
#var dialogue_line = await resource.get_next_dialogue_line("start")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
