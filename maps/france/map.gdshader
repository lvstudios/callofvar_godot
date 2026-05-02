shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 5.0) = 2.5;
uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 0.1);
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // Récupère l'image derrière avec du flou
    vec4 color = textureLod(screen_texture, SCREEN_UV, blur_amount);
    
    // Applique une légère teinte blanche/grise pour l'effet verre
    COLOR = mix(color, tint_color, tint_color.a);
}