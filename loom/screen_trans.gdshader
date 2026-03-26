shader_type canvas_item;
uniform bool reverse = false;
uniform float progress : hint_range(0, 1);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (reverse){
		if (UV.x + UV.y <= progress * 2.0) {
			discard;
		}
	} else {
		if (UV.x + UV.y >= progress * 2.0){
			discard;
		}
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
