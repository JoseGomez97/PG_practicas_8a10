#version 420 core

$GLMatrices
$Lights

// Atributos del vértice (sistema de coordenadas del modelo)
in vec4 position;
in vec2 texCoord;
in vec3 normal;
in vec3 tangent;

// Añade las variables out que necesites
out vec2 TexCoord;
out vec3 Lvert;
out vec3 Vvert;

void main()
{
	vec3 eN = normalize(normalMatrix * normal);
	vec3 eposition = vec3(modelviewMatrix * position);
	vec3 V = normalize(-eposition.xyz);
	vec3 L;
	if(lights[0].directional == 0) {
		L = normalize(vec3(lights[0].positionEye) - eposition);
	} else {
		L = normalize(vec3(lights[0].positionEye));
	}
	vec3 T = mat3(modelviewMatrix) * tangent;
	vec3 B = cross(eN, T);
	mat3 R = mat3(T, B, eN);

	// Propagamos variables
	Lvert = R * L;
	Vvert = R * V;
	TexCoord = vec2(texCoord);
	gl_Position = modelviewprojMatrix * position;
}
