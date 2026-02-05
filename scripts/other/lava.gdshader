shader_type canvas_item;

uniform vec4 color_lava : source_color = vec4(1.0, 0.3, 0.0, 1.0);
uniform vec4 color_bright : source_color = vec4(1.0, 0.6, 0.0, 1.0);
uniform float speed = 1.0;

void fragment() {
	// 1. UVs auf 16x16 Pixel festlegen (Pixel-Art Erhalt)
	vec2 grid = vec2(16.0, 16.0);
	vec2 uv = floor(UV * grid) / grid;
	
	// 2. Zwei Sinus-Wellen für organisches Brodeln kombinieren
	float noise = sin(uv.x * 10.0 + TIME * speed) * cos(uv.y * 10.0 + TIME * speed * 0.5);
	noise += sin(uv.y * 20.0 - TIME * speed * 0.2);
	
	// 3. Den Noise-Wert normalisieren (auf Bereich 0 bis 1)
	noise = (noise + 2.0) / 4.0;
	
	// 4. Farben basierend auf dem Noise mischen
	vec4 final_color = mix(color_lava, color_bright, step(0.6, noise));
	
	// Optional: Ein leichtes dunkles Glühen an den Rändern der "Blasen"
	if (noise < 0.4) {
		final_color *= 0.8;
	}
	
	COLOR = final_color;
}