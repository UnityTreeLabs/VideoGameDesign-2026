extends Node
var thread_max = 1
var threads = []
var pierce_wall = false
var dash = false
var string = false
var string_distance = 750
var health = 3
var double_jump = false
var checkpoints = []
var current_checkpoint = 10
var shake_strength = 0
var shake_fade = 0
var shake_camera = null
var forest = false
var rng = RandomNumberGenerator.new()
var loaded = false
var intro = true
var checkpoint_spawn = true
var spawn_location = 0
var seals = [false, false, false, false]
@onready var trans_screen = Transition.get_node("Screen")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1.2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength, 0, shake_fade * delta)
		if shake_camera:
			shake_camera.offset = Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

func freeze(duration: float) -> void:
	get_tree().paused = true
	await get_tree().create_timer(duration, true, false, true).timeout
	get_tree().paused = false
	Engine.time_scale = 1.2

func shake(strength: float, fade: float) -> void:
	shake_camera = get_tree().current_scene.get_node("Background/Camera2D")
	shake_strength += strength
	shake_fade = fade

func alert(header: String, text: String) -> void:
	var tween = create_tween()
	var header_node = Ui.get_node("UI/Header")
	var text_node = Ui.get_node("UI/Text")
	header_node.modulate.a = 0
	text_node.modulate.a = 0
	header_node.text = header
	text_node.text = text
	tween.tween_property(header_node, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(text_node, "modulate:a", 1.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(header_node, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(text_node, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT_IN)

func change_scene(scene: String, id: int = 1, type: int = 1) -> void:
	if type:
		checkpoint_spawn = true
	else:
		checkpoint_spawn = false
	spawn_location = id
	var tween = create_tween()
	tween.tween_callback(trans_screen.material.set_shader_parameter.bind("reverse", false))
	tween.tween_method(set_trans, 0.0, 1.0, 2.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	if type:
		tween.tween_property(global, "health", 3, 0)
	tween.tween_callback(get_tree().change_scene_to_file.bind("res://screen_" + scene + ".tscn"))

func set_trans(progress: float) -> void:
	trans_screen.material.set_shader_parameter("progress", progress)
