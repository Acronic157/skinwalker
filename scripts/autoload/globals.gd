extends Node


# Signals
signal restart_level
signal enter_main_menu
signal next_level



# Variables
@onready var player_posessing := false

@onready var game_over := false

@onready var current_level := 0

@onready var game_paused := false

@onready var player_max_health := 100.0
@onready var player_health := 100.0

@onready var level_complete := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
