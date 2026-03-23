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
var current_checkpoint = null
var shake_strength = 0
var shake_fade = 0
var shake_camera = null
var forest = false
var rng = RandomNumberGenerator.new()

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
	var header_node = get_tree().current_scene.get_node("CanvasLayer/UI/Header")
	var text_node = get_tree().current_scene.get_node("CanvasLayer/UI/Text")
	header_node.text = header
	text_node.text = text
	tween.tween_property(header_node, "modulate:a", 1.0, 1.0)
	tween.tween_property(text_node, "modulate:a", 1.0, 1.5)
	
	tween.tween_property(header_node, "modulate:a", 0.0, 1.0)
	tween.tween_property(text_node, "modulate:a", 0.0, 0.5)
