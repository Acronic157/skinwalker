extends Node2D



@onready var game_over: Control = $ui/GameOver



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Game Over Mechanic
	if Globals.game_over:
		game_over.visible = true
		get_tree().paused = true
		# game over screen einblenden
		# Spiel pausieren





func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "enter_level":
		get_tree().paused = false
		Globals.current_level += 1
