extends Node2D
@export var checkpoint_num = 0
@export var notif = false
@export var header = ""
@export var text = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if checkpoint_num in global.checkpoints:
		$Sprite2D.frame = 1
		$Sprite2D2.self_modulate = Color(1, 1, 1, 1)
		$PointLight2D.energy = 0.75


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if global.current_checkpoint != checkpoint_num:
		Ui.get_node("UI").checkpoint()
		if notif:
			global.alert(header, text)
		global.checkpoints.append(checkpoint_num)
		global.current_checkpoint = checkpoint_num
		var light_tween = create_tween()
		var glow_tween = create_tween()
		global.health = 3
		if $Sprite2D.frame == 0:
			$Sprite2D.frame = 1
			glow_tween.tween_property($Sprite2D2, "self_modulate", Color(1, 1, 1, 1), 5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			light_tween.tween_property($PointLight2D, "energy", 0.75, 5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		else:
			glow_tween.tween_property($Sprite2D2, "self_modulate", Color(1, 1, 1, 0.5), 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			glow_tween.tween_property($Sprite2D2, "self_modulate", Color(1, 1, 1, 1), 5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
			light_tween.tween_property($PointLight2D, "energy", 0.5, 0.25).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			light_tween.tween_property($PointLight2D, "energy", 0.75, 5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
