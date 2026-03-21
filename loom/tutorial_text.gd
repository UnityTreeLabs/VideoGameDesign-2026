extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate.a = (500.0 - (get_tree().current_scene.get_node("Player/PlayerBody").global_position - (global_position + (size * 0.5))).length())/300.0
	if modulate.a < 0:
		modulate.a = 0
