extends Area2D
@export var ID = 0
@export var target = "0"
@export var speed = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(transition)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func transition(body: Node2D) -> void:
	set_deferred("monitoring", false)
	body.get_node("Area2D").process_mode = Node.PROCESS_MODE_DISABLED
	global.change_scene(target.left(-1), int(target[-1]), 0) 
