shader_type canvas_item;
uniform float flashState : hint_range(0, 1) = 0;

void fragment() {
    vec4 texture_color = COLOR;
	
    COLOR = mix(vec4(5, 5, 5, texture_color.a), texture_color, 1.0 - flashState);
}