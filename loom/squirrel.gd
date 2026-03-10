extends CharacterBody2D


const SPEED = 10000
const JUMP_VELOCITY = -400.0
@onready var follow_point = get_parent().get_node("Path2D/PathFollow2D")
var chasing = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	follow_point.progress_ratio += delta * 0.25
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if get_node("PlayerDetection").is_colliding() and $FloorDetection.is_colliding():
		velocity.x = 0
		if chasing:
			velocity.x = SPEED * 1.5 * delta * scale.y
			get_parent().get_node("ChaseEnd").stop()
		elif get_parent().get_node("ChaseStart").is_stopped():
			get_parent().get_node("ChaseStart").start()
	elif not chasing:
		if follow_point.global_position.x > global_position.x:
			scale.y = 1
			rotation = 0
			velocity.x = SPEED * delta
		else:
			rotation_degrees = 180
			scale.y = -1
			velocity.x = -SPEED * delta
	elif get_parent().get_node("ChaseEnd").is_stopped():
		velocity.x = 0
		get_parent().get_node("ChaseEnd").start()
		

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(get_parent(), "modulate", Color(1.44, 1.825, 1.035, 1.0) * 3, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(get_parent().queue_free)


func _on_chase_start_timeout() -> void:
	if get_node("PlayerDetection").is_colliding():
		chasing = true

func _on_chase_end_timeout() -> void:
	chasing = false
