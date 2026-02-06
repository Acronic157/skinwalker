extends Node


# Signals
signal restart_level
signal enter_main_menu
signal next_level
signal enter_enemy
signal exit_enemy


# Variables
@onready var player_posessing := false

@onready var game_over := false

@onready var current_level := 0

@onready var PauseMenu = preload("res://scenes/menus/pause_menu.tscn")
@onready var game_paused := false

@onready var player_max_health := 100.0
@onready var player_health := 100.0

@onready var level_completed := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pause_menu: Node = PauseMenu.instantiate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
