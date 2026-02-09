extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var direction = 0
var can_jump = false
var jumping = false

@onready var thread = preload("res://thread.tscn")

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
		if get_parent().get_node("CoyoteTime").is_stopped() and can_jump:
			get_parent().get_node("CoyoteTime").start()
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
	
	if Input.is_action_just_pressed("ui_click"):
		var instance = thread.instantiate()
		instance.global_position = global_position
		instance.rotation = atan2(get_local_mouse_position().y, get_local_mouse_position().x)
		get_parent().get_parent().add_child(instance)
		
	move_and_slide()


func _on_coyote_time_timeout() -> void:
	can_jump = false
