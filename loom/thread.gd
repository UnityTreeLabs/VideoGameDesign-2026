extends RigidBody2D

const SPEED = 900
var constant_rotation = 0
var num = 0
var moving = 1
var velocity = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().get_parent().get_node("Player/PlayerBody").destroy_thread.connect(_on_destroy_thread)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector2(900, 0).rotated(get_parent().rotation) * moving
	angular_velocity = 0
	rotation = 0
	if move_and_collide(velocity * delta, false, 0.08, true) != null:
		collision_layer = 2
		freeze = true
		moving = 0
		linear_velocity = Vector2(0, 0)
	if moving == 0 and move_and_collide(Vector2(0.09, 0).rotated(get_parent().rotation), true, 0.08, true) == null:
		get_parent().queue_free()
	$Line2D.remove_point(1)
	$Line2D.add_point(get_parent().get_parent().get_node("Player/PlayerBody").global_position - global_position)
	$Line2D.rotation = -get_parent().rotation

func _on_body_entered(body: Node) -> void:
	collision_layer = 6
	moving = 0
	linear_velocity = Vector2(0, 0)
	
func _on_timer_timeout() -> void:
	get_parent().queue_free()

func _on_destroy_thread() -> void:
	num -= 1
	if num == 0:
		get_parent().queue_free()

func _initialize(thread_num) -> void:
	num = thread_num
