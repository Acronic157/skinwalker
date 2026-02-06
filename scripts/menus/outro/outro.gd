extends Node2D

@onready var lamp: AnimatedSprite2D = $lamp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_lamp_animation_finished() -> void:
	Globals.next_level.emit()

func _on_dialogue_ended():
		lamp.play("default")
