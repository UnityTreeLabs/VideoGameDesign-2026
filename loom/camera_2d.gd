extends Camera2D
@onready var player = get_parent().get_parent().get_node("Player/PlayerBody")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position_smoothing_speed = 0
	offset = player.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
