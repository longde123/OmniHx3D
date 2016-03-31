#ifdef GL_ES
precision highp float;
#endif

// Uniforms
uniform vec2 u_texelDelta;

// Atributes
attribute vec4 position;

// Output
varying vec2 vUV;
varying vec4 v_texcoord0;
varying vec4 v_texcoord1;
varying vec4 v_texcoord2;
varying vec4 v_texcoord3;
varying vec4 v_texcoord4;
varying vec4 v_texcoord5;
varying vec4 v_texcoord6;

float scaleoffset = 0.8; //edge detection offset

void main()
{
	float x = u_texelDelta.x * scaleoffset;
	float y = u_texelDelta.y * scaleoffset;
	vec2 dg1 = vec2(x, y);
	vec2 dg2 = vec2(-x, y);
	vec2 dx  = vec2(x, 0.0);
	vec2 dy  = vec2(0.0, y);
	gl_Position = vec4(position, 0.0, 1.0);
	
	v_texcoord0 = vUV.xyxy;
	v_texcoord1.xy = v_texcoord0.xy - dy;
	v_texcoord2.xy = v_texcoord0.xy + dy;
	v_texcoord3.xy = v_texcoord0.xy - dx;
	v_texcoord4.xy = v_texcoord0.xy + dx;
	v_texcoord5.xy = v_texcoord0.xy - dg1;
	v_texcoord6.xy = v_texcoord0.xy + dg1;
	v_texcoord1.zw = v_texcoord0.xy - dg2;
	v_texcoord2.zw = v_texcoord0.xy + dg2;
}