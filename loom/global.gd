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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Engine.time_scale = 1.2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func freeze(duration: float) -> void:
	Engine.time_scale = 0
	await get_tree().create_timer(duration, true, false, true).timeout
	Engine.time_scale = 1
