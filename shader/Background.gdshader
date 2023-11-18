shader_type canvas_item;

uniform float tileFactor = 3;
uniform float aspect = 1.0;
uniform float scroll_speed = 0.08;


void fragment(){
	vec2 adjustedUV = UV * tileFactor;
	adjustedUV.y *= aspect;
	vec2 uv = adjustedUV;
	uv.x = UV.x * 1.0 + pow(abs(sin(3.14 * UV.x/2.0)),2.0);
	COLOR = texture(TEXTURE, uv + (scroll_speed * TIME));
}