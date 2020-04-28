#version 420 core

in vec3 position;
in vec2 texCoord;

out VS_OUT {
	vec2 textureCoord;
} vs_out;

void main()
{
	// Tomamos los tres bits menos significativos como la coordenada en X
	int x = gl_InstanceID & 63;
	// Y los siguientes tres bits como la coordenada en Y
	int y = gl_InstanceID >> 6;
	
	// Movemos la instancia a su sitio
	vec3 newpos = position - vec3(float(x) - 32.0, position.y, float(y) - 32.0);

	gl_Position = vec4(newpos, 1.0);
	vs_out.textureCoord = texCoord + vec2(-x*1/64.0f, y*1/64.0f);
}
