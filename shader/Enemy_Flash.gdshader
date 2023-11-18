//shader_type canvas_item;
//
//const float PI = 3.141516;
//
//uniform float speed = 1.;
//
//uniform vec4 tint : hint_color = vec4(1., 1., 0., 1.);
//
//uniform float span : hint_range(0.1, 1.) = .3;
//
//float luminance(vec4 colour) {
//	return 1.0 - sqrt(0.299*colour.r*colour.r + 0.587*colour.g*colour.g + 0.114*colour.b*colour.b);
//}
//
//void fragment() {
//	vec4 colour = texture(TEXTURE, UV);
//	float target = abs(sin(TIME * PI * speed) * (1. + span));
//	if(colour.a > 0.) {
//		float lum = luminance(colour);
//		float diff = abs(lum - target);
//		float mx = clamp(1. - diff / span, 0., 1.);
//		colour = mix(colour, tint, mx);
//	}
//
//	COLOR = colour;
//}

shader_type canvas_item;

uniform bool bFlashOn = true;
uniform float speed = 1.0f;
uniform vec4 tint : hint_color = vec4(1., 1., 0., 1.);
uniform float span : hint_range(0.1, 1.) = .3;

float luminance(vec4 color){
	return 1.0 - sqrt(0.299*color.r*color.r + 0.587*color.g*color.g + 0.114*color.b*color.b);
}

void fragment(){
	vec4 color = texture(TEXTURE, UV);
	if (bFlashOn){
		float target = abs(sin(TIME * speed));
		if (color.a > 0.0){
			float lum = luminance(color);
			float dif = abs(lum - target);
			float mx = clamp(1. - dif / span, 0., 1.);
			color = mix (color, tint, mx);
		}
	}
	COLOR = color;
}