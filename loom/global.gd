extends Node
var thread_max = 1
var threads = []
var pierce_wall = false
var dash = false
var string = false
var string_distance = 1000
var health = 3
var double_jump = true
var checkpoints = []
var current_checkpoint = null
var shake_strength = 0
var shake_fade = 0
var shake_camera = null
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
	Engine.time_scale = 0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1.2

func shake(strength: float, fade: float) -> void:
	shake_camera = get_tree().current_scene.get_node("Background/Camera2D")
	shake_strength += strength
	shake_fade = fade
