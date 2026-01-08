extends Node2D

const SPEED = 900
var moving = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(SPEED * delta * moving)
	move_local_x(SPEED * delta * moving)

func _on_player_body_shoot_thread(location) -> void:
	global_position = get_parent().get_node("PlayerBody").global_position
	rotation = atan2((location.y-global_position.y), (location.x-global_position.x))
	show()

func _on_area_2d_body_entered(body: Node2D) -> void:
	moving = 0
	while get_node("Area2D").get_overlapping_bodies().size() >= 1:
		move_local_x(-1)
