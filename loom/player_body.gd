extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var direction = 0
var can_jump = false
var jumping = false
var can_shoot = true
var thread_num = 0
signal destroy_thread

@onready var thread = preload("res://thread.tscn")
@onready var camera = get_parent().get_parent().get_node("Camera2D")
@onready var coyote_time = get_parent().get_node("CoyoteTime")

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:

	# Handle jump.
	if Input.is_action_just_pressed("ui_up") and can_jump:
		velocity.y = JUMP_VELOCITY
		jumping = true
		can_jump = false
		
	if not (Input.is_action_pressed("ui_up") and jumping and velocity.y < 0):
		jumping = false
		
	# Add the gravity.
	if not is_on_floor():
		if coyote_time.is_stopped() and can_jump:
			coyote_time.start()
		velocity += get_gravity() * delta * (1.25 - int(jumping) * 0.5)
	else:
		can_jump = true
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.flip_h = (direction - 1)/2
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if Input.is_action_just_pressed("ui_click") and can_shoot:
		can_shoot = false
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
		
	move_and_slide()
	
	if direction:
		camera.position_smoothing_speed = 3.5
		camera.global_position = global_position + Vector2(150 * direction, 0)
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
