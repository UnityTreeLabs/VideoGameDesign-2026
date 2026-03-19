extends CharacterBody2D


const SPEED = 7500
const JUMP_VELOCITY = -400.0
const SHOOT_VELOCITY = 2000
var rng = RandomNumberGenerator.new()
var player = null
@export var health = 3
@onready var projectile = preload("res://projectile.tscn")

func _ready() -> void:
	rng.randomize()
	material = material.duplicate()	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	if $AnimatedSprite2D.frame == 3 and $AnimatedSprite2D.animation == "attack" :
		shoot(player.global_position - global_position + Vector2(0, 25))
	if true:
		player = get_tree().current_scene.get_node("Player/PlayerBody")
		if not $AnimatedSprite2D.animation == "attack":
			if player.global_position.x > global_position.x:
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
		if true:
			velocity.x = 0
			if $ShootCooldown.is_stopped() and $AnimatedSprite2D.animation == "default":
				$AnimatedSprite2D.play("attack")
				$ShootCooldown.wait_time = rng.randf_range(1, 2.5)
				$ShootCooldown.start()
	else:
		if (get_parent().global_position - global_position).length() < 50:
			velocity.x = 0
		elif get_parent().global_position.x > global_position.x:
			scale.y = 1
			rotation = 0
			$GPUParticles2D.scale.y = 1
			$GPUParticles2D.rotation = 0
			velocity.x = (SPEED * delta)
		else:
			rotation_degrees = 180
			scale.y = -1
			$GPUParticles2D.scale.y = -1
			$GPUParticles2D.rotation_degrees = 180
			velocity.x = -SPEED * delta
	if $AnimatedSprite2D.animation == "attack":
		velocity.x = 0
	if velocity.x == 0 and $AnimatedSprite2D.animation != "default" and $AnimatedSprite2D.animation != "attack":
		$AnimatedSprite2D.play_backwards("start_run")
	elif velocity.x != 0 and $AnimatedSprite2D.animation == "default":
		$AnimatedSprite2D.play("start_run")
	if $AnimatedSprite2D.animation == "start_run":
		velocity.x *= $AnimatedSprite2D.frame / 10.0
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var tween = create_tween()
	material.set_shader_parameter("flashState", 0.7)
	var particles = $GPUParticles2D
	
	particles.process_material.direction = Vector3((global_position - body.global_position).x, (global_position - body.global_position).y, 0)
	
	global.freeze(0.1)
	global.shake(10, 5)
	health -= 1
	tween.tween_callback(material.set_shader_parameter.bind("flashState", 0)).set_delay(0.1)
	if health == 0:
		collision_layer = 0
		global.freeze(1)
		global.shake(50, 5)
		tween.tween_property(particles, "emitting", true, 0)
		tween.tween_property($AnimatedSprite2D, "modulate:a", 0, 0.1)
		tween.tween_property(get_parent(), "process_mode", PROCESS_MODE_DISABLED, 0)
		await particles.finished
		get_parent().queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "start_run":
		if $AnimatedSprite2D.frame == 0:
			$AnimatedSprite2D.play("default")
		else:
			$AnimatedSprite2D.play("running")
	elif $AnimatedSprite2D.animation == "attack":
		$AnimatedSprite2D.play("default")

func shoot(location: Vector2) -> void:
	var object = projectile.instantiate()
	var g = get_gravity().y + 50
	location.x += rng.randf_range(-50, 50)
	location.y += rng.randf_range(-20, 20)
	object.global_position = global_position + Vector2(0, -25)
	object.start_velocity = Vector2(SHOOT_VELOCITY, 0).rotated(atan2(SHOOT_VELOCITY ** 2 - sqrt(SHOOT_VELOCITY ** 4 - g * (g * location.x ** 2 + 2 * SHOOT_VELOCITY ** 2 * velocity.y)), g * location.x)).bounce(Vector2(0, 1))
	get_parent().get_parent().add_child(object)
	object.force_update_transform()
	object.show()
