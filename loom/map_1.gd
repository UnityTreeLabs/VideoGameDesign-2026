extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Transition.get_node("Screen").material.set_shader_parameter("progress", 0.0)
	Transition.get_node("Screen").material.set_shader_parameter("reverse", true)
	var trans_tween = create_tween()
	trans_tween.tween_method(set_trans, 0.0, 1.0, 2.0).set_delay(0.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	if global.string:
		get_node("Key/StringPower").queue_free()
	if global.dash:
		get_node("Key/DashPower").queue_free()
	if global.double_jump:
		get_node("Key/DoubleJumpPower").queue_free()
	if global.thread_max == 2:
		get_node("Key/ExtraThreadPower").queue_free()
	if global.pierce_wall:
		get_node("Key/PiercePower").queue_free()
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


func _on_boss_zone_body_entered(body: Node2D) -> void:
	$Key/BossZone.set_deferred("monitoring", false)
	$Background/Camera2D.limit_enabled = true
	var spikes = []
	for i in range(-2, 1):
		for j in range(-16, -12):
			spikes.append(Vector2i(i, j))
	$Spikes.set_cells_terrain_connect(spikes, 0, 0)
	var map = []
	for coords in spikes:
		map.append(Vector2i(coords.x - 1, coords.y))
	$TileMapLayer.set_cells_terrain_connect(map, 0, 0)

func set_trans(progress: float) -> void:
	Transition.get_node("Screen").material.set_shader_parameter("progress", progress)
