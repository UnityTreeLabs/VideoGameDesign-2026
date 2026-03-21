extends CharacterBody2D


const SPEED = 10000
const JUMP_VELOCITY = -400.0
@onready var follow_point = get_parent().get_node("Path2D/PathFollow2D")
var chasing = false
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	$AnimatedSprite2D.set_frame_and_progress(rng.randi_range(0, 3), rng.randf())
	$"../ChaseStart".wait_time = randf_range(0.1, 0.3)
	$"../ChaseEnd".wait_time = randf_range(0.1, 0.3)
	material = material.duplicate()

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
			$GPUParticles2D.scale.y = 1
			$GPUParticles2D.rotation = 0
			velocity.x = SPEED * delta
		else:
			rotation_degrees = 180
			scale.y = -1
			$GPUParticles2D.scale.y = -1
			$GPUParticles2D.rotation_degrees = 180
			velocity.x = -SPEED * delta
	elif get_parent().get_node("ChaseEnd").is_stopped():
		velocity.x = 0
		get_parent().get_node("ChaseEnd").start()
		

	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var tween = create_tween()
	material.set_shader_parameter("flashState", 0.7)
	var particles = $GPUParticles2D
	particles.process_material.direction = Vector3((global_position - body.global_position).x, (global_position - body.global_position).y, 0)
	collision_layer = 0
	global.shake(5, 5)
	global.freeze(0.05)
	tween.tween_callback(material.set_shader_parameter.bind("flashState", 0)).set_delay(0.1)
	tween.tween_property(particles, "emitting", true, 0)
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0, 0.1)
	tween.tween_property(get_parent(), "process_mode", PROCESS_MODE_DISABLED, 0)
	await particles.finished
	get_parent().queue_free()


func _on_chase_start_timeout() -> void:
	if get_node("PlayerDetection").is_colliding():
		chasing = true

func _on_chase_end_timeout() -> void:
	chasing = false
