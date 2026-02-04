extends Node2D

@onready var animation_player: AnimationPlayer = $textur/AnimationPlayer

@export var button: Node2D

var has_fallen := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	has_fallen = false
	animation_player.play("swinging")
	if button:
		button.button_pressed.connect(_on_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed():
	if not has_fallen:
		animation_player.play("falling")
		has_fallen = true
