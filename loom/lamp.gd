extends Node2D
@export var checkpoint_num = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	$Sprite2D.frame = 1
	global.checkpoints.append(checkpoint_num)
	global.current_checkpoint = checkpoint_num
	var light_tween = create_tween()
	var glow_tween = create_tween()
	glow_tween.tween_property($Sprite2D2, "self_modulate", Color(1, 1, 1, 1), 5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	light_tween.tween_property($PointLight2D, "energy", 1, 5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
