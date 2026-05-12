extends Control

var particles = [preload("res://shatter_particles.tres"), preload("res://projectile_trail.tres"), preload("res://damage_splash.tres"), preload("res://projectile_splash.tres"), preload("res://bear_death.tres"), preload("res://snake_death.tres"), preload("res://squirrel_death.tres")]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Ui.hide()
	if not global.loaded:
		for item in particles:
			var instance = GPUParticles2D.new()
			instance.set_process_material(item)
			instance.set_one_shot(true)
			instance.set_modulate(Color(1, 1, 1, 0))
			instance.set_emitting(true)
			add_child(instance)
		global.loaded = true
	var tween = create_tween()
	if Transition.get_node("Screen").material.get_shader_parameter("progress") == 1:
		Transition.get_node("Screen").material.set_shader_parameter("progress", 0.0)
		Transition.get_node("Screen").material.set_shader_parameter("reverse", true)
		tween.tween_method(set_trans, 0.0, 1.0, 2.0).set_delay(0.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_property($CanvasLayer/Title, "modulate:a", 1.0, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT).set_delay(0.5)
	tween.tween_property($CanvasLayer/Title, "global_position:y", -40.0, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property($CanvasLayer/PlayButton, "disabled", false, 0)
	tween.tween_property($CanvasLayer/PlayButton, "modulate:a", 1.0, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	$CanvasLayer/PlayButton.disabled = true
	Transition.get_node("Screen").material.set_shader_parameter("reverse", false)
	Transition.get_node("Screen").material.set_shader_parameter("progress", 0.0)
	var tween = create_tween()
	tween.tween_method(set_trans, 0.0, 1.0, 2.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	if global.intro:
		tween.tween_callback(get_tree().change_scene_to_file.bind("res://introduction.tscn"))
	else:
		global.change_scene(str(floori(global.current_checkpoint / 10.0)), global.current_checkpoint % 10, 1)

func set_trans(progress: float) -> void:
	Transition.get_node("Screen").material.set_shader_parameter("progress", progress)
