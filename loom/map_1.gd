extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not global.forest:
		global.alert("STARLESS GROVE", "The darkness where light dies")
		global.forest = true
	if global.checkpoints:
		for lamp in $Key/Lamps.get_children():
			if lamp.checkpoint_num == global.current_checkpoint:
				$Player/PlayerBody.global_position = lamp.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pierce_collect(body: Node2D) -> void:
	#
	global.alert("", "Needles can pierce walls")
	global.pierce_wall = true
	get_node("Key/PiercePower").queue_free()


func _on_dash_collect(body: Node2D) -> void:
	# 
	global.alert("GLEAMSTRIDE", "Press Shift to Dash")
	global.dash = true
	get_node("Key/DashPower").queue_free()
	


func _on_thread_collect(body: Node2D) -> void:
	# 
	global.alert("", "Needle quantity is increased")
	global.thread_max = 2
	$Player/PlayerBody.can_shoot += 1
	get_node("Key/ExtraThreadPower").queue_free()


func _on_string_connect(body: Node2D) -> void:
	# 
	global.alert("THE LIGHT BETWEEN", "Connect Needles and Anchors with E")
	global.string = true
	get_node("Key/StringPower").queue_free()


func _on_double_jump_collect(body: Node2D) -> void:
	global.alert("", "Press jump in the air to double jump")
	global.double_jump = true
	get_node("Key/DoubleJumpPower").queue_free()
