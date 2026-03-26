shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (COLOR.b > 0.8 && COLOR.r > 0.8 && COLOR.g > 0.8) {
		COLOR += vec4(1.0, 1.0, 1.0, 1.0) * 2.0;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
