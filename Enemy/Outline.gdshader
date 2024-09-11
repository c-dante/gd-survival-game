shader_type canvas_item;

uniform vec3 outline_color: source_color;
uniform float progress: hint_range(0.0, 4.0);

void fragment() {
  COLOR = mix(COLOR, vec4(outline_color,  COLOR.a), progress - COLOR.a * progress);
}
