shader_type canvas_item;
uniform float flashState : hint_range(0, 1) = 0;
uniform float scarfGlow;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
	vec4 cur_color = COLOR;
	
    COLOR = mix(vec4(5, 5, 5, cur_color.a), cur_color, 1.0 - flashState);
	
	if (COLOR.b > 0.90 && COLOR.a != 0.0 && COLOR.r == 1.0){
		COLOR += vec4(1.353, 1.301, 1.123, 1);
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
