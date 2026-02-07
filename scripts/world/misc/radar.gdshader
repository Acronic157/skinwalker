shader_type canvas_item;

// Einstellungen im Inspektor
uniform vec4 pulse_color : source_color = vec4(0.4, 1.0, 0.4, 1.0); // Ein helleres Grün
uniform float speed : hint_range(0.0, 10.0) = 3.0;                  // Geschwindigkeit
uniform float intensity : hint_range(0.0, 1.0) = 0.5;              // Stärke des Glühens

void fragment() {
    // Die originale Textur (dein Kreis mit Gradient)
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Erzeugt eine Sinus-Welle zwischen 0.0 und 1.0
    float wave = (sin(TIME * speed) + 1.0) * 0.5;
    
    // Wir nehmen nur die Alpha-Werte deines Sprites, 
    // damit das Glühen genau die Form des Kreises behält.
    vec3 glow = pulse_color.rgb * wave * intensity;
    
    // Addiere das Glühen zur Originalfarbe
    // Wir multiplizieren mit tex_color.a, damit das Glühen nicht im leeren Raum erscheint
    vec3 final_color = tex_color.rgb + (glow * tex_color.a);
    
    COLOR = vec4(final_color, tex_color.a);
}