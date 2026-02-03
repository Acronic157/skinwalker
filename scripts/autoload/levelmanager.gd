extends Node

var current_level := 1
var level_unlocked := 1
var max_level := 8

func _unlock_level(level_to_unlock: int) -> void:
	if level_to_unlock > level_unlocked:
		level_unlocked = level_to_unlock

func _load_level(level_to_load: int) -> String:
	if level_to_load > max_level:
		return "res://scenes/world/level/main_menu.tscn"
	return str("res://scenes/world/level/", level_to_load, ".tscn")
