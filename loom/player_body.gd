extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const FORCE = 20
var direction = 0
var can_jump = false
var can_double = false
var jumping = false
var can_shoot = 1
var thread_num = 0
var dashing = false
var dash_cooldown = false
var can_dash = false
var string_cooldown = false
var vy_before = 0
var spam_cooldown = false

signal destroy_thread
signal connect_string(coords, threads, type)

@onready var thread = preload("res://thread.tscn")
@onready var camera = get_parent().get_parent().get_node("Background/Camera2D")
@onready var coyote_time = get_parent().get_node("CoyoteTime")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and (can_jump or can_double):
		velocity.y = JUMP_VELOCITY
		var squash_tween = create_tween()
		squash_tween.tween_property($Sprite2D, "scale", Vector2(0.8, 1.1), 0.07).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		squash_tween.tween_property($Sprite2D, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
		jumping = true
		if can_jump:
			can_jump = false
		else:
			can_double = false
		
		
	if not (Input.is_action_pressed("ui_up") and jumping and velocity.y < 0):
		jumping = false
		
	if Input.is_action_pressed("ui_down"):
		collision_mask = 2
	else:
		collision_mask = 66
		
	
	# Add the gravity.
	if not is_on_floor():
		if coyote_time.is_stopped() and can_jump:
			coyote_time.start()
		if not dashing:
			velocity += get_gravity() * delta * (1.25 - int(jumping) * 0.6)
	elif not dashing:
		if global.double_jump:
			can_double = true
		can_jump = true
		can_dash = true
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not dashing:
		direction = Input.get_axis("ui_left", "ui_right")
	
	if direction:
		if dashing:
			velocity.x = 4 * direction * SPEED
		else:
			if sign(velocity.x) == sign(direction*SPEED) and abs(velocity.x) > abs(direction*SPEED):
				velocity.x = move_toward(velocity.x, direction * SPEED, abs(velocity.x)/20)
			else:
				velocity.x = move_toward(velocity.x, direction * SPEED, SPEED)
		$Sprite2D.flip_h = (-direction + 1)/2
	else:
		if abs(velocity.x) > SPEED:
			velocity.x = move_toward(velocity.x, 0, abs(velocity.x)/20)
		else:
			
			velocity.x = move_toward(velocity.x, 0, abs(velocity.x)/2)
	if abs(velocity.x) < 2 * SPEED:
		$Area2D.monitoring = true
		
	#apply_floor_snap()
	#floor_snap_length = 5
	floor_max_angle = 3 * PI / 8
	floor_stop_on_slope = false
	
	vy_before = velocity.y
	move_and_slide()
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider is RigidBody2D and collider.name != "ThreadBody":
			collider.apply_central_impulse(-get_slide_collision(i).get_normal() * FORCE)
			#collider.apply_central_impulse(-get_slide_collision(i).get_normal() * FORCE * (vy_before/200)**2)
			
	if Input.is_action_just_pressed("interact") and global.string and not string_cooldown:
		var start_end = [null, null]
		$"../StringCooldown".start()
		string_cooldown = true
		
		if global.thread_max >= 2 and global.threads.size() >= 2:
			connect_string.emit(start_end, [], 1)
		elif $Area2D2.has_overlapping_bodies():
			start_end[0] = $Area2D2.get_overlapping_bodies()[0].global_position
			connect_string.emit(start_end, [], 0)
	if Input.is_action_just_pressed("ui_click") and can_shoot and not spam_cooldown:
		can_shoot -= 1
		spam_cooldown = true
		$"../SpamCooldown".start()
		var light_tween = create_tween()
		var mod_tween = create_tween()
		light_tween.tween_property($PointLight2D, "energy", 0.5, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		light_tween.tween_property($PointLight2D, "energy", 0.2, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		mod_tween.tween_property($"..", "modulate", Color(2.454, 2.363, 2.042) * 1, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		mod_tween.tween_property($"..", "modulate", Color(1.572, 1.572, 1.499), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		var timer = get_parent().get_node("BasicCooldown").duplicate()
		get_parent().add_child(timer)
		timer.start()
		if global.thread_max <= global.threads.size():
			destroy_thread.emit()
		var instance = thread.instantiate()
		instance.global_position = global_position
		instance.rotation = atan2(get_local_mouse_position().y, get_local_mouse_position().x)
		get_parent().get_parent().add_child(instance)
	
	if Input.is_action_just_pressed("dash") and global.dash and can_dash and not dash_cooldown:
		dashing = true
		var squash_tween = create_tween()
		squash_tween.tween_property($Sprite2D, "scale", Vector2(1.3, 0.8), 0.07).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		squash_tween.tween_property($Sprite2D, "scale", Vector2(1, 1), 0.12).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
		$Area2D.monitoring = false
		can_jump = false
		can_dash = false
		dash_cooldown = true
		direction = -(int($Sprite2D.flip_h) * 2 - 1)
		$"../DashDuration".start()
		
	camera.global_position = global_position
	camera.position_smoothing_speed = 4
	#if velocity.x != 0:
		#camera.position_smoothing_speed = 3.5
		#camera.global_position = global_position + Vector2(150 * sign(velocity.x), 0)
	#else:
		#if abs(velocity.y) > 100:
			#camera.position_smoothing_speed = 3.5
		#else:
			#camera.position_smoothing_speed = 3.5
		#camera.global_position = global_position
	


func _on_coyote_time_timeout() -> void:
	can_jump = false


func _on_basic_cooldown_timeout() -> void:
	can_shoot += 1


func _on_dash_duration_timeout() -> void:
	dashing = false
	$"../DashCooldown".start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if $"../InvDuration".is_stopped():
		global.health -= 1
		var tween = create_tween()
		tween.tween_method(material.set_shader_parameter().bind("flashState"), 0, 1, 1)
		tween.tween_property(self, "modulate", Color(1.818, 1.825, 1.538) * 1.2, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0.3), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT_IN)
		tween.tween_property(self, "modulate", Color(1, 1, 1, 0.3), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT_IN)
		if global.health <= 0:
			global.health = 3
			get_tree().reload_current_scene()
		else:
			$"../InvDuration".start()


func _on_dash_cooldown_timeout() -> void:
	dash_cooldown = false


func _on_string_cooldown_timeout() -> void:
	string_cooldown = false

func _on_spam_cooldown_timeout() -> void:
	spam_cooldown = false
