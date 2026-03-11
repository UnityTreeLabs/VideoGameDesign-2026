extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if global.checkpoints:
		for lamp in $Key/Lamps.get_children():
			print(lamp)
			print(lamp.checkpoint_num)
			print(global.current_checkpoint)
			if lamp.checkpoint_num == global.current_checkpoint:
				$Player/PlayerBody.global_position = lamp.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pierce_collect(body: Node2D) -> void:
	# Arrow of God
	global.pierce_wall = true
	get_node("Key/PiercePower").queue_free()


func _on_dash_collect(body: Node2D) -> void:
	# On the Road
	global.dash = true
	get_node("Key/DashPower").queue_free()
	


func _on_thread_collect(body: Node2D) -> void:
	# 
	global.thread_max = 2
	$Player/PlayerBody.can_shoot += 1
	get_node("Key/ExtraThreadPower").queue_free()


func _on_string_connect(body: Node2D) -> void:
	# A Tale of Two Cities
	global.string = true
	get_node("Key/StringPower").queue_free()
