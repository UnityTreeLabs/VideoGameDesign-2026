shader_type canvas_item;
uniform float scarfGlow;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
	vec4 cur_color = COLOR;
	
	
	if (COLOR.a != 0.0 && COLOR.r >= 0.9 && COLOR.b >= 0.5){
		if (COLOR.b >= 0.9) {
			COLOR += vec4(1.353, 1.301, 1.123, 0);
		} else {
			COLOR += vec4(1.353, 1.301, 0.0, 0);
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
