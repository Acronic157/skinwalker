shader_type canvas_item;

uniform vec4 shine_color : source_color = vec4(1.0, 0.9, 0.5, 0.5);
uniform float cycle_speed : hint_range(0.0, 10.0) = 2.0;
uniform float shine_size : hint_range(0.0, 1.0) = 0.15;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Erzeugt ein sanftes Pulsieren basierend auf der Zeit
    float pulse = (sin(TIME * cycle_speed) + 1.0) * 0.5;
    
    // Markiert die Oberkante des Tiles (One-Way Effekt)
    // Wenn UV.y klein ist (oben), wird die Farbe gemischt
    float edge_mask = smoothstep(shine_size, 0.0, UV.y);
    
    // Kombiniere die Originalfarbe mit einem goldenen Schimmer an der Kante
    vec3 final_rgb = mix(tex_color.rgb, shine_color.rgb, edge_mask * pulse * shine_color.a);
    
    // Optional: Ein ganz leichter Glüheffekt für das gesamte Tile
    final_rgb += shine_color.rgb * pulse * 0.05;

    COLOR = vec4(final_rgb, tex_color.a);
}