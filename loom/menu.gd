extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween()
	tween.tween_property($CanvasLayer/Title, "modulate:a", 1.0, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(0.5)
	tween.tween_property($CanvasLayer/Title, "global_position:y", -40.0, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property($CanvasLayer/PlayButton, "disabled", false, 0)
	tween.tween_property($CanvasLayer/PlayButton, "modulate:a", 1.0, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	$CanvasLayer/PlayButton.disabled = true
	var tween = create_tween()
	tween.tween_method(set_trans, 0.0, 1.0, 2.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(get_tree().change_scene_to_file.bind("res://map_1.tscn"))
func set_trans(progress: float) -> void:
	Transition.get_node("Screen").material.set_shader_parameter("progress", progress)
