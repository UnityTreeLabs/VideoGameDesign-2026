extends CharacterBody2D


const SPEED = 750
const JUMP_VELOCITY = -400.0
var chasing = false
var diving = false
var range = 350
var player = null
var target_location = Vector2(0, 0)
var attack_velocity = Vector2(0, 0)
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	range *= randf_range(0.9, 1.1)
	$AnimatedSprite2D.set_frame_and_progress(rng.randi_range(0, 3), rng.randf())
	material = material.duplicate()

func _physics_process(delta: float) -> void:
	if player and (player.global_position - global_position).length() >= 1000:
		chasing = false
	if chasing:
		if diving:
			velocity = attack_velocity
			rotation = atan2(velocity.y, velocity.x)
		else:
			if $AttackStartup.is_stopped():
				$AttackStartup.start()
			if player.global_position.x > global_position.x:
				scale.y = 1
				rotation = 0
				$GPUParticles2D.scale.y = 1
				$GPUParticles2D.rotation = 0
				$WallDetection.scale.y = 1
				$WallDetection.rotation = 0
				target_location = player.global_position + Vector2(range, 0).rotated(5*PI/4)
			else:
				rotation_degrees = 180
				scale.y = -1
				$GPUParticles2D.scale.y = -1
				$GPUParticles2D.rotation_degrees = 180
				$WallDetection.scale.y = -1
				$WallDetection.rotation_degrees = 180
				target_location = player.global_position + Vector2(range, 0).rotated(7*PI/4)
			velocity.y = move_toward(velocity.y, (Vector2(1, 0) * SPEED).rotated(atan2(target_location.y - global_position.y, target_location.x - global_position.x)).y/(atan((target_location - global_position).length() - 10) + PI/2), 10)
			velocity.x = move_toward(velocity.x, (Vector2(1, 0) * SPEED).rotated(atan2(target_location.y - global_position.y, target_location.x - global_position.x)).x/(atan((target_location - global_position).length() - 10) + PI/2), 10)
			if $WallDetection.is_colliding():
				$AttackStartup.paused = true
			else:
				$AttackStartup.paused = false
	else:
		velocity.y = move_toward(velocity.y, 0, 10)
		velocity.x = move_toward(velocity.x, 0, 10)
	move_and_slide()
	if player:
		$WallDetection.target_position = (player.global_position - global_position)/2


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


func _on_player_detection_body_entered(body: Node2D) -> void:
	chasing = true
	player = body


func _on_attack_startup_timeout() -> void:
	if chasing:
		diving = true
		attack_velocity = (Vector2(3, 0) * SPEED).rotated(atan2(player.global_position.y - global_position.y, player.global_position.x - global_position.x))/(atan((player.global_position - global_position).length() - 10) + PI/2)
		$AttackDuration.start()

func _on_attack_duration_timeout() -> void:
	diving = false
	$AttackStartup.start()
