extends Node2D

signal button_pressed
@onready var button_pressed_sprite: Sprite2D = $button_pressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_interact_area_area_entered(area: Area2D) -> void:
	button_pressed.emit()
	button_pressed_sprite.visible = true
	


func _on_interact_area_area_exited(area: Area2D) -> void:
	button_pressed_sprite.visible = false
