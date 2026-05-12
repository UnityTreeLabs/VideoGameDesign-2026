extends Node2D
var click = false
var jump = false
var dash = false
var interact = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_click"):
		click = true
	if Input.is_action_just_pressed("dash"):
		dash = true
	if Input.is_action_just_pressed("ui_up"):
		jump = true
	if Input.is_action_just_pressed("interact"):
		interact = true
