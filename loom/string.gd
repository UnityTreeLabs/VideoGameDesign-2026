extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Line2D.points.remove_at(1)
	$Line2D.points.append(get_parent().get_parent().get_node("Player/PlayerBody").global_position)
