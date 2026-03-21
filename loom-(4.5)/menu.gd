extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Instantly switches to map1
	get_tree().change_scene_to_file("res://map_1.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
