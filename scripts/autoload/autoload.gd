extends Node2D


@onready var ambient_1: AudioStreamPlayer2D = $audio/ambient_1
@onready var ambient_2: AudioStreamPlayer2D = $audio/ambient_2
@onready var game_over_sound: AudioStreamPlayer2D = $audio/game_over_sound


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not Globals.game_over:
		if Levelmanager.current_level >= 1 and Levelmanager.current_level < 5:
			if not ambient_1.playing:
				ambient_1.playing = true
		else:
			ambient_1.playing = false
			
		if Levelmanager.current_level >= 5 and Levelmanager.current_level < 10:
			if not ambient_2.playing:
				ambient_2.playing = true
		else:
			ambient_2.playing = false
	else:
		ambient_1.playing = false
		ambient_2.playing = false
		if not game_over_sound.playing:
			game_over_sound.playing = true
