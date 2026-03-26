extends CharacterBody2D


const SPEED = 30000
const JUMP_VELOCITY = -400.0
const SHOOT_VELOCITY = 500
var active = false
var rng = RandomNumberGenerator.new()
var player = null
var charge = false
var roar = false
var attack_pattern = 0
var proj_num = 12
var flipped = -1
@export var health = 20
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
	if active:
		if $AttackCooldown.is_stopped():
			if attack_pattern == 0:
				$AnimatedSprite2D.play("roar")
				$AttackCooldown.wait_time = randf_range(3.0, 4.0)
				$AttackCooldown.start()
				attack_pattern = 1
			else:
				$AnimatedSprite2D.play("charge")
				$AttackCooldown.wait_time = randf_range(3.0, 4.0)
				$AttackCooldown.start()
				attack_pattern = 0
		if $AnimatedSprite2D.animation == "roar" and $AnimatedSprite2D.frame >= 4 and $AnimatedSprite2D.frame <= 14:
			global.shake(1, 5)
			if $ShootCooldown.is_stopped():
				player = get_tree().current_scene.get_node("Player/PlayerBody")
				shoot(player.global_position - global_position)
				$ShootCooldown.wait_time = randf_range(0.4, 0.75)
				$ShootCooldown.start()
		if $AnimatedSprite2D.animation == "charge":
			if (position.x >= 0 and flipped == 1):
				flipped = -1
				rotation_degrees = 180
				scale.y = -1
				$AnimatedSprite2D.play("idle")
				velocity.x = 0
			elif (position.x <= -314 and flipped == -1):
				flipped = 1
				rotation_degrees = 0
				scale.y = 1
				$AnimatedSprite2D.play("idle")
				velocity.x = 0
			else:
				velocity.x = delta * SPEED * flipped
			
	
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
	if $AnimatedSprite2D.animation == "roar":
		$AnimatedSprite2D.play("idle")

func shoot(location: Vector2) -> void:
	location -= Vector2(225 * flipped, -30)
	for i in range(proj_num):
		var object = projectile.instantiate()
		object.particles = false
		object.gravity = false
		object.color = Color(3.061, 1.567, 1.37, 1.0)
		object.global_position = global_position + Vector2(225 * flipped, -30)
		object.start_velocity = Vector2(SHOOT_VELOCITY, 0).rotated(atan2(location.y, location.x) + i * 2 * PI / proj_num)
		get_parent().get_parent().add_child(object)
		object.force_update_transform()
		object.show()
