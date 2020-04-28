#version 420 core

// Teselation control

layout (vertices = 4) out;

in VS_OUT {
	vec2 textureCoord;
} from_vs[];

out TESC_OUT {
	vec2 textureCoord;
} to_tese[];


$GLMatrices

void main() {
	// Propagamos la posición y la coordenada de textura al shader de evaluación
	gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;
	to_tese[gl_InvocationID].textureCoord = from_vs[gl_InvocationID].textureCoord;

	// TODO Modificar altura en función a color imagen
	//gl_out[gl_InvocationID].gl_Position.y = ;
	
	vec3 edgePosition[4];
	float edgeDistance[4];

	for (int i = 0; i < 4; i++) {
		edgePosition[i] = vec3(modelviewMatrix * ((gl_out[i].gl_Position + gl_out[(i+1)%4].gl_Position) / 2.0f));
		
		edgeDistance[i] = distance(edgePosition[i], vec3(0.0,0.0,0.0));
	}

	/*
		Calcula aquí los niveles de teselación
	*/
	if (gl_InvocationID == 0) {
		gl_TessLevelOuter[0] = 64.0 / max(edgeDistance[3], 1.0f);
		gl_TessLevelOuter[1] = 64.0 / max(edgeDistance[2], 1.0f);
		gl_TessLevelOuter[2] = 64.0 / max(edgeDistance[1], 1.0f);
		gl_TessLevelOuter[3] = 64.0 / max(edgeDistance[0], 1.0f);

		gl_TessLevelInner[0] = (gl_TessLevelOuter[0] + gl_TessLevelOuter[2]) / 2.0f;
		gl_TessLevelInner[1] = (gl_TessLevelOuter[1] + gl_TessLevelOuter[3]) / 2.0f;
	}
}
