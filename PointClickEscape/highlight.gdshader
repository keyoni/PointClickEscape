shader_type canvas_item;

uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float shine_speed : hint_range(0.0, 20.0, 0.1) = 1.0;
uniform float shine_size : hint_range(0.01, 1.0, 0.01) = 0.01;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float alpha = tex_color.a;
    
    float shine = step(1.0 - shine_size * 0.5, 0.5 + 0.5 * sin(UV.x - UV.y + TIME * shine_speed));
    shine *= alpha;  // Multiply shine by alpha

    COLOR.rgb = mix(tex_color.rgb, shine_color.rgb, shine);
    COLOR = max(tex_color.a, shine * shine_color.a);  // Set alpha to max of tex_color alpha and shine
}