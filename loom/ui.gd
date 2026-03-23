extends Control
var health = 3


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i.name.begins_with("Heart"):
			i.material.set_shader_parameter("flashState", 0)
			i.texture.current_frame = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global.health != health:
		if global.health > health:
			for i in range(global.health, health, -1):
				var tween = create_tween()
				get_node("Heart" + str(i)).texture.current_frame = 0
				tween.tween_method(flash.bind(i), 0.0, 1.0, 1.0)
				#tween.tween_property(get_node("Heart" + str(i)).texture, "current_frame", 0, 0)
				tween.tween_method(flash.bind(i), 1.0, 0.0, 0.2)
			health = global.health
		else:
			for i in range(health, global.health, -1):
				var tween = create_tween()
				flash(1, i)
				tween.tween_method(flash.bind(i), 1.0, 0.0, 0.5)
				get_node("Heart" + str(i)).texture.current_frame = 1
				get_node("Heart" + str(i)).get_node("GPUParticles2D").emitting = true
			health = global.health

func flash(progress: float, num: int) -> void:
	get_node("Heart" + str(num)).material.set_shader_parameter("flashState", progress)
