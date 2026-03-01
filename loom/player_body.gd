extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
const FORCE = 20
var direction = 0
var can_jump = false
var jumping = false
var can_shoot = true
var thread_num = 0
var dashing = false
var dash_cooldown = false
var can_dash = false

signal destroy_thread

@onready var thread = preload("res://thread.tscn")
@onready var camera = get_parent().get_parent().get_node("Background/Camera2D")
@onready var coyote_time = get_parent().get_node("CoyoteTime")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and can_jump:
		velocity.y = JUMP_VELOCITY
		var squash_tween = create_tween()
		squash_tween.tween_property($Sprite2D, "scale", Vector2(0.8, 1.1), 0.07).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
		squash_tween.tween_property($Sprite2D, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
		jumping = true
		can_jump = false
		
	if not (Input.is_action_pressed("ui_up") and jumping and velocity.y < 0):
		jumping = false
		
	# Add the gravity.
	if not is_on_floor():
		if coyote_time.is_stopped() and can_jump:
			coyote_time.start()
		if not dashing:
			velocity += get_gravity() * delta * (1.25 - int(jumping) * 0.5)
	elif not dashing:
		
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
	if abs(velocity.x) < SPEED * 2:
		$Area2D.monitoring = true
		
	move_and_slide()
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider is RigidBody2D and collider.name != "ThreadBody":
			collider.apply_central_impulse(-get_slide_collision(i).get_normal() * FORCE)
	
	if Input.is_action_just_pressed("ui_click") and can_shoot:
		can_shoot = false
		var light_tween = create_tween()
		var mod_tween = create_tween()
		light_tween.tween_property($PointLight2D, "energy", 0.5, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		light_tween.tween_property($PointLight2D, "energy", 0.2, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		mod_tween.tween_property($"..", "modulate", Color(2.454, 2.363, 2.042) * 1, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		mod_tween.tween_property($"..", "modulate", Color(1.572, 1.572, 1.499), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		get_parent().get_node("BasicCooldown").start()
		if global.thread_max <= thread_num:
			destroy_thread.emit()
			thread_num -= 1
		var instance = thread.instantiate()
		thread_num += 1
		instance.global_position = global_position
		instance.get_node("ThreadBody").num = thread_num
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
		
	
	if velocity.x != 0:
		camera.position_smoothing_speed = 3.5
		camera.global_position = global_position + Vector2(150 * sign(velocity.x), 0)
	else:
		if abs(velocity.y) > 100:
			camera.position_smoothing_speed = 3.5
		else:
			camera.position_smoothing_speed = 3.5
		camera.global_position = global_position
	


func _on_coyote_time_timeout() -> void:
	can_jump = false


func _on_basic_cooldown_timeout() -> void:
	can_shoot = true


func _on_dash_duration_timeout() -> void:
	dashing = false
	$"../DashCooldown".start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()


func _on_dash_cooldown_timeout() -> void:
	dash_cooldown = false
