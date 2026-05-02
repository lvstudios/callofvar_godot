shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 5.0) = 2.5; // <--- AJOUTE CETTE LIGNE
uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 0.1);
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    // ... reste du code
}