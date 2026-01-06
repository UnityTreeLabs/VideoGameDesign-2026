extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("shoot_thread", _shoot_thread)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _shoot_thread(location):
	pass
