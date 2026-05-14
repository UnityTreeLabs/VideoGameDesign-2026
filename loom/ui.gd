extends Control
var health = 3
var seals = [false, false, false, false]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if i.name.begins_with("Heart"):
			if i.material.get_shader_parameter("flashState") != 0:
				i.material.set_shader_parameter("flashState", 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#for i in range(1, 4):
		#if health >= i:
			#get_node("Heart" + str(i)).texture.region.position.x = 0
		#else:
			#get_node("Heart" + str(i)).texture.region.position.x = 32
	
	if global.health != health:
		if global.health > health:
			for i in range(global.health, health, -1):
				var tween = create_tween()
				get_node("Heart" + str(i)).texture.region.position.x = 0
				tween.tween_method(flash.bind(i), 0.0, 1.0, 1.0)
				#tween.tween_property(get_node("Heart" + str(i)).texture, "current_frame", 0, 0)
				tween.tween_method(flash.bind(i), 1.0, 0.0, 0.2)
			health = global.health
		else:
			for i in range(health, global.health, -1):
				var tween = create_tween()
				flash(1, i)
				tween.tween_method(flash.bind(i), 1.0, 0.0, 0.5)
				get_node("Heart" + str(i)).texture.region.position.x = 32
				get_node("Heart" + str(i)).get_node("GPUParticles2D").emitting = true
			health = global.health
	for i in range(4):
		if global.seals[i] and not seals[i]:
			var tween = create_tween()
			tween.tween_property(get_node("Seal" + str(i)), "modulate", Color(1, 1, 1), 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func flash(progress: float, num: int) -> void:
	get_node("Heart" + str(num)).material.set_shader_parameter("flashState", progress)

func checkpoint():
	var tween = create_tween()
	tween.tween_property($Checkpoint, "modulate:a", 1.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($Checkpoint, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT).set_delay(0.5)
