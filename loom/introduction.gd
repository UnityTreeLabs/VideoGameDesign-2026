extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Ui.hide()
	Transition.get_node("Screen").material.set_shader_parameter("reverse", false)
	Transition.get_node("Screen").material.set_shader_parameter("progress", 0.0)
	var tween = create_tween()
	tween.tween_property($Visible, "visible_characters", 23, 1.5).set_delay(4.0)
	tween.tween_property($Visible, "modulate:a", 0.0, 1.0).set_delay(2.0)
	tween.tween_callback(reset_text.bind("But you knew that already, didn't you?"))
	tween.tween_property($Visible, "visible_characters", 26, 1.7).set_delay(1.0)
	tween.tween_property($Visible, "visible_characters", 38, 0.78).set_delay(0.5)
	tween.tween_property($Visible, "modulate:a", 0.0, 1.0).set_delay(2.0)
	tween.tween_callback(reset_text.bind("[left]That's what you came to stop.[/left][right]What you will stop.[/right]"))
	tween.tween_property($Visible, "visible_characters", 29, 1.89).set_delay(1.0)
	tween.tween_property($Visible, "visible_characters", 48, 1.24).set_delay(1.0)
	tween.tween_property($Visible, "modulate:a", 0.0, 1.0).set_delay(2.0)
	tween.tween_callback(reset_text.bind("[left]You, who holds the world in your hands.[/left][center]You, who weaves the string of fate.[/center][right]You, who pierces the dark.[/right]"))
	tween.tween_property($Visible, "visible_characters", 39, 2.54).set_delay(1.0)
	tween.tween_property($Visible, "visible_characters", 74, 2.28).set_delay(0.75)
	tween.tween_property($Visible, "visible_characters", 100, 1.7).set_delay(0.75)
	tween.tween_property($Visible, "modulate:a", 0.0, 1.0).set_delay(2.0)
	tween.tween_callback(reset_text.bind("You, who they call\n\n"))
	tween.tween_property($Visible, "visible_characters", 18, 2.5).set_delay(1.0)
	tween.tween_property($Weaver, "modulate:a", 1.0, 2.0).set_delay(1.5)
	tween.tween_property($Visible, "modulate:a", 0.0, 1.0).set_delay(1.25)
	tween.tween_property($Weaver, "modulate:a", 0.0, 1.0).set_delay(0.75)
	tween.tween_callback(reset_text.bind("Come. Let's begin."))
	tween.tween_property($Visible, "visible_characters", 5, 0.56).set_delay(1.0)
	tween.tween_property($Visible, "visible_characters", 18, 1.44).set_delay(0.5)
	tween.tween_property($ColorRect2, "modulate:a", 1, 5.0).set_delay(1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.parallel().tween_property($CanvasModulate, "color", Color(18.892, 18.892, 18.892), 5.0).set_delay(1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(Transition.get_node("Screen"), "color", Color(1.353, 1.353, 1.353), 1.0)
	tween.tween_callback(Transition.get_node("Screen").material.set_shader_parameter.bind("progress", 1.0))
	tween.tween_callback(get_tree().change_scene_to_file.bind("res://screen_1.tscn"))
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset_text(text: String) -> void:
	$Visible.text = text
	$Visible.visible_characters = 0
	$Visible.modulate.a = 1.0
