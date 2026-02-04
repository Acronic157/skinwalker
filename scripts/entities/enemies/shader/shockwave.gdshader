shader_type canvas_item;

uniform float strength: hint_range(0.0, 0.1, 0.001) = 0.08;
uniform vec2 center = vec2(0.5, 0.5);
uniform float radius: hint_range(0.0, 1.0, 0.001) = 0.25;

uniform float aberration: hint_range(0.0, 1.0, 0.001) = 0.425;
uniform float width: hint_range(0.0, 0.1, 0.0001) = 0.04;
uniform float feather: hint_range(0.0, 1.0, 0.001) = 0.135;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    vec2 st = SCREEN_UV;
    float aspect_ratio = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
    vec2 scaled_st = (st - vec2(0.5, 0.5)) / vec2(1.0, aspect_ratio) + vec2(0.5, 0.5); 
    
    vec2 dist_center = scaled_st - center;
    float dist_len = length(dist_center);
    
    // Die Maske berechnet, wo der Ring ist
    float mask = (1.0 - smoothstep(radius - feather, radius, dist_len)) * smoothstep(radius - width - feather, radius - width, dist_len);
    
    // Versatz berechnen (nur dort, wo mask > 0)
    vec2 offset = normalize(dist_center) * strength * mask;
    vec2 biased_st = st - offset; // Wir nutzen hier st statt scaled_st für die Textur-Abfrage
    
    // Chromatic Aberration Vektor
    vec2 abber_vec = offset * aberration;
    
    // Farben abgreifen
    // Wir nutzen biased_st, da dort die Verzerrung stattfindet
    vec4 red = texture(SCREEN_TEXTURE, biased_st + abber_vec);
    vec4 blue = texture(SCREEN_TEXTURE, biased_st - abber_vec);
    vec4 ori = texture(SCREEN_TEXTURE, biased_st);
    
    // Das Ergebnis: Alpha wird auf 'mask' gesetzt!
    COLOR = vec4(red.r, ori.g, blue.b, mask);
}