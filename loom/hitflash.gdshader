shader_type canvas_item;
uniform float flashState : hint_range(0, 1) = 0;
uniform float scarfGlow;


void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
	vec4 cur_color = COLOR;
	
    COLOR = mix(vec4(5, 5, 5, cur_color.a), cur_color, 1.0 - flashState);
	
	if (texture_color.b < 0.93 && texture_color.r >= 0.9 && texture_color.g >= 0.9 && texture_color.a > 0.5){
		COLOR = mix(vec4(1.353, 1.301, 1.123, 0) * scarfGlow, cur_color, 1.0);
	}
}