extends Camera2D
@onready var player = get_parent().get_node("Player/PlayerBody")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.direction:
		position_smoothing_speed = 5
		global_position = player.global_position + Vector2(100 * player.direction, 0)
	else:
		position_smoothing_speed = 2
		global_position = player.global_position
