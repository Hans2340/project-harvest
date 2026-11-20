shader_type canvas_item;
// Gentle wind sway for trees, grass, reeds and crops. The top of the sprite moves, the base
// stays put. Offsets are rounded to whole texture pixels so pixel art stays crisp.
// Each sprite gets its own phase from its world position, so one material serves all.

uniform float strength = 1.2;   // max sway at the top, in texture pixels
uniform float speed = 1.3;
uniform float gust = 0.0;       // extra sway (set by weather)

void vertex() {
	float top = 1.0 - UV.y;
	float phase = MODEL_MATRIX[3].x * 0.013 + MODEL_MATRIX[3].y * 0.007;
	float s = sin(TIME * speed + phase) + 0.4 * sin(TIME * speed * 2.3 + phase * 1.7);
	VERTEX.x += round(s * (strength + gust) * top);
}
