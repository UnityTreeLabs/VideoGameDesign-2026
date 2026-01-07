extends Node2D

var velocity = Vector2(0, 0)
const SPEED = 900

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_local_x(SPEED * delta)

func _on_player_body_shoot_thread(location) -> void:
	global_position = get_parent().get_node("PlayerBody").global_position
	rotation = atan2((location.y-global_position.y), (location.x-global_position.x))
	velocity = Vector2(location.x-global_position.x, location.y-global_position.y)
	print(velocity)
	show()
