extends RigidBody2D

const SPEED = 900
var constant_rotation = 0
var num = 0
var moving = 1
var velocity = Vector2(0, 0)
var start = false
var finished = false
@export var glow = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = get_parent().get_parent().get_node("Player/PlayerBody").global_position
	
	get_parent().get_parent().get_node("Player/PlayerBody").destroy_thread.connect(_on_destroy_thread)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start:
		velocity = Vector2(SPEED, 0).rotated(get_parent().rotation) * moving
		angular_velocity = 0
		rotation = 0
		var collision = move_and_collide(velocity * delta, false, 0.08, true)
		if collision != null:
			if (collision.get_collider() is TileMapLayer and (collision.get_collider().tile_set.get_physics_layer_collision_layer(0) & 8 == 8 or global.pierce_wall)):
				collision_layer = 2
				freeze = true
				moving = 0
				linear_velocity = Vector2(0, 0)
			else:
				collision_layer = 0
				freeze = true
				moving = -0.1
				linear_velocity = Vector2(0, 0)
				finished = true
				$AnimatedSprite2D.play_backwards("creation")
		if moving == 0 and move_and_collide(Vector2(0.09, 0).rotated(get_parent().rotation), true, 0.08, true) == null:
			finished = true
			$AnimatedSprite2D.play_backwards("creation")
		$Line2D.remove_point(1)
		$Line2D.add_point(get_parent().get_parent().get_node("Player/PlayerBody").global_position - global_position)
		$Line2D.rotation = -get_parent().rotation
	else:
		if $Area2D.has_overlapping_bodies() and $AnimatedSprite2D.frame >= 15:
			collision_layer = 0
			moving = -0.1
			start = true
			finished = true
			$AnimatedSprite2D.play_backwards("creation")
		else:
			global_position = get_parent().get_parent().get_node("Player/PlayerBody").global_position

func _on_body_entered(body: Node) -> void:
	if ((body.get_class() == "TileMapLayer" and body.tile_set.get_physics_layer_collision_layer(0) & 8 == 8) or global.pierce_wall) and moving != 1 and not finished:
		collision_layer = 2
		moving = 0
		linear_velocity = Vector2(0, 0)
	else:
		collision_layer = 0
		freeze = true
		moving = -0.1
		linear_velocity = Vector2(0, 0)
		finished = true
		$AnimatedSprite2D.play_backwards("creation")
	
func _on_timer_timeout() -> void:
	collision_layer = 0
	finished = true
	$AnimatedSprite2D.play_backwards("creation")

func _on_destroy_thread() -> void:
	num -= 1
	if num == 0:
		collision_layer = 0
		moving = -0.1
		finished = true
		$AnimatedSprite2D.play_backwards("creation")

func _initialize(thread_num) -> void:
	num = thread_num


func _on_air_timer_timeout() -> void:
	if moving and not finished:
		collision_layer = 0
		moving = 0.1
		finished = true
		$AnimatedSprite2D.play_backwards("creation")


func _on_animated_sprite_2d_animation_finished() -> void:
	if not finished:
		$CollisionShape2D.disabled = false
		start = true
		$"../AirTimer".start()
	else:
		get_parent().queue_free()
	


func _on_animated_sprite_2d_frame_changed() -> void:
	$PointLight2D.energy = $AnimatedSprite2D.frame / 16.0 * glow
