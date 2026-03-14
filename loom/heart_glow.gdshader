shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 texture_color = COLOR;
	if (COLOR.b > 0.90 && COLOR.a != 0.0 && COLOR.r == 1.0){
		COLOR += vec4(1.353, 1.301, 1.123, 1);
	} else if (COLOR.a != 0.0) {
		
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
