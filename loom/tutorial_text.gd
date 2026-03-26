extends RichTextLabel
@export var req_string = false
@export var req_djump = false
@export var req_eneedle = false
@export var req_dash = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate.a = (500.0 - (get_tree().current_scene.get_node("Player/PlayerBody").global_position - (global_position + (size * 0.5))).length())/300.0
	if modulate.a < 0:
		modulate.a = 0
	if (req_string and not global.string) or (req_djump and not global.double_jump) or (req_eneedle and not global.thread_max == 2) or (req_dash and not global.dash):
		modulate.a = 0
