extends RigidBody2D

const SPEED = 900
@onready var string = preload("res://string.tscn")
var constant_rotation = 0
var moving = 1
var velocity = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector2(900, 0).rotated(get_parent().rotation) * moving
	angular_velocity = 0
	rotation = 0
	$Line2D.remove_point(1)
	$Line2D.add_point(get_parent().get_parent().get_parent().get_node("Player/PlayerBody").global_position)
	move_and_collide(velocity * delta)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	moving = 0
	linear_velocity = Vector2(0, 0)
	
