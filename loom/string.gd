extends Node2D
@export var start = Vector2(0, 0)
@export var end = Vector2(0, 0)
var distance = 0
var animation_part_n = 0
var parts_list = []
var destroy = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	distance = (start - end).length()
	if distance > global.string_distance or distance < 32:
		queue_free()
	global_position = start
	$StringEnd.global_position = end
	$StartPart.rotation = (end-start).angle()
	$StringPart.rotation = (end-start).angle()
	if fmod(distance, 32) < 2:
		distance -= 32 + fmod(distance, 32)
		$StringPart.global_position = start + Vector2(32, 0).rotated((end-start).angle())
	else:
		$StringPart.global_position = start + Vector2(fmod(distance, 32), 0).rotated((end-start).angle())
		$StartPart/Line2D.points[1] = Vector2(fmod(distance, 32), 0)
		$StartPart/CollisionShape2D.scale.x = fmod(distance, 32)/32
		
	
	
	for i in range(0, round(distance - fmod(distance, 32)), 32):
		var new_part = $StringPart.duplicate()
		var new_joint = $StringJoint.duplicate()
		new_part.get_node("AnimatedSprite2D").hide()
		new_part.get_node("AnimatedSprite2D").animation_finished.connect(_thread_anim.bind(new_part))
		new_joint.global_position = new_part.global_position
		if parts_list:
			new_joint.node_a = parts_list[-1].get_path()
		else:
			new_joint.node_a = $StartPart.get_path()
		add_child(new_part)
		add_child(new_joint)
		new_joint.node_b = new_part.get_path()
		parts_list.append(new_part)
		$StringPart.global_position += Vector2(32, 0).rotated((end-start).angle())
	if parts_list:
		parts_list[0].get_node("AnimatedSprite2D").play()
		parts_list[0].get_node("AnimatedSprite2D").show()
		parts_list[0].get_node("Line2D").show()
		$EndJoint.global_position = $StringEnd.global_position
		$EndJoint.node_a = parts_list[-1].get_path()
		#var new_joint = $StringJoint.duplicate()
		#new_joint.global_position = $StringEnd.global_position
		#new_joint.node_a = parts_list[-1].get_path()
		#new_joint.node_b = $StringEnd.get_path()
		#add_child(new_joint)
	else:
		$EndJoint.global_position = $StringEnd.global_position
		#var new_joint = $StringJoint.duplicate()
		#new_joint.global_position = $StringEnd.global_position
		#new_joint.node_a = $StartPart.get_path()
		#new_joint.node_b = $StringEnd.get_path()
		#add_child(new_joint)a
	$StringJoint.hide()
	$StringPart.hide()
		
		
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _thread_anim(part: Node2D):
	if not destroy:
		part.collision_layer = 64
		if parts_list.size() > animation_part_n + 1:
			animation_part_n += 1
			parts_list[animation_part_n].get_node("AnimatedSprite2D").show()
			parts_list[animation_part_n].get_node("Line2D").show()
			parts_list[animation_part_n].get_node("AnimatedSprite2D").play()
	elif destroy:
		if animation_part_n == 0:
			queue_free()
		else:
			parts_list[animation_part_n].get_node("AnimatedSprite2D").hide()
			parts_list[animation_part_n].get_node("Line2D").hide()
			parts_list[animation_part_n].collision_layer = 0
			animation_part_n -= 1
			parts_list[animation_part_n].get_node("AnimatedSprite2D").speed_scale = -1
			parts_list[animation_part_n].get_node("AnimatedSprite2D").play()

func delete():
	destroy = true
	if parts_list:
		parts_list[animation_part_n].get_node("AnimatedSprite2D").speed_scale = -1
		parts_list[animation_part_n].get_node("AnimatedSprite2D").play()
	else:
		queue_free()
