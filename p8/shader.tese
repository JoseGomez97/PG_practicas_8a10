#version 420 core

layout (quads, fractional_even_spacing, ccw) in;

$GLMatrices

uniform	sampler2D texUnitHeightMap;

// Teselation evaluation

in TESC_OUT {
	vec2 textureCoord;
} from_tesc[];

out TESE_OUT {
	vec2 textureCoord;
};

void main() {
	vec2 t1 = mix(from_tesc[0].textureCoord, from_tesc[1].textureCoord, gl_TessCoord.x);
	vec2 t2 = mix(from_tesc[3].textureCoord, from_tesc[2].textureCoord, gl_TessCoord.x);

	textureCoord = mix(t1, t2, gl_TessCoord.y);

	// Calcular la posici�n del v�rtice teselado como una interpolaci�n bilineal
	vec4 p1 = mix(gl_in[0].gl_Position, gl_in[1].gl_Position, gl_TessCoord.x);
	vec4 p2 = mix(gl_in[3].gl_Position, gl_in[2].gl_Position, gl_TessCoord.x);

	vec4 planePosition = mix(p1, p2, gl_TessCoord.y);

	// Modificar altura en funci�n a color imagen
	planePosition.y += texture(texUnitHeightMap, textureCoord).r * 3;

	gl_Position = modelviewprojMatrix * planePosition;
}
