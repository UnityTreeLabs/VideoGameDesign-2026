extends RigidBody2D
@export var start = Vector2(0, 0)
@export var start_velocity = Vector2(0, 0)
var gravity = true
var particles = true
var color = Color(1.998, 1.585, 3.061)
var finished = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#global_position = start
	collision_layer = 16
	gravity_scale = int(gravity)
	$GPUParticles2D.emitting = particles
	$Sprite2D.modulate = color
	$GPUParticles2D2.modulate = color
	linear_velocity = start_velocity


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	if not finished:
		finished = true
		var tween = create_tween()
		var tween2 = create_tween()
		$GPUParticles2D2.process_material.direction = Vector3(-linear_velocity.normalized().x, -linear_velocity.normalized().y, 0)
		$GPUParticles2D2.emitting = true
		$GPUParticles2D.emitting = false
		linear_velocity *= 0.2
		set_deferred("gravity_scale", 0)
		set_deferred("freeze", true)
		
		set_deferred("collision_layer", 0)
		set_deferred("collision_mask", 0)
		tween.tween_property($Sprite2D, "scale", Vector2(3, 3), 0.3)
		tween2.tween_property($Sprite2D, "modulate:a", 0, 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		await $GPUParticles2D2.finished
		queue_free()
