extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pierce_collect(body: Node2D) -> void:
	global.pierce_wall = true
	get_node("Key/PiercePower").queue_free()


func _on_dash_collect(body: Node2D) -> void:
	global.dash = true
	get_node("Key/DashPower").queue_free()
	
