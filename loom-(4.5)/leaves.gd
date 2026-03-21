extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var camera_position = get_parent().get_node("Camera2D").global_position
	$GPUParticles2D.process_material.emission_shape_offset = Vector3(camera_position.x, camera_position.y, 0)
