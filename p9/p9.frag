#version 420 core

$Lights

layout (binding=$TEXDIFF) uniform sampler2D colores;
layout (binding=$TEXNORM) uniform sampler2D normales;
layout (binding=$TEXSPEC) uniform sampler2D brillos;
// Descomenta este sampler cuando estés preparado para usarlo
layout (binding=$TEXHEIGHT) uniform sampler2D alturas;

uniform bool useParallax;
uniform float scaleFactor;
uniform float biasValue;

in vec2 TexCoord;
in vec3 Lvert;
in vec3 Vvert;
out vec4 fragColor;

vec4 iluminacion(vec4 color, vec3 N, vec3 V, vec3 L, float b) {

    // color = Componente emisiva del material

    // L = Vector iluminación (desde vértice a la fuente)

    // Multiplicador de la componente difusa
    float diffuseMult = max(dot(N, L), 0.0);

    float specularMult = 0.0;
    if (diffuseMult > 0.0) {
        // Multiplicador de la componente especular
        vec3 R = reflect(-L, N);
        specularMult = max(0.0, dot(R, V));
        specularMult = pow(specularMult, 20);
    }

    // Efecto foco
    float efectoFoco;
    if (lights[0].spotCutoff == 180) // La fuente no es focal
    {
        efectoFoco = 1;
    }
    else if (max(dot(-L,lights[0].spotDirectionWorld), 0) < lights[0].spotCosCutoff) // Vértice fuera del cono iluminado
    { 
        efectoFoco = 0;
    }
    else
    {
        efectoFoco = pow(max(dot(-L,lights[0].spotDirectionWorld), 0), lights[0].spotExponent);
    }

    color += efectoFoco *
                ( lights[0].ambient*0 +
                lights[0].diffuse * diffuseMult * 0.15 +
                lights[0].specular * specularMult * b * 0.8 );

  return color;
}

void main()
{

    vec3 l = normalize(Lvert);
    vec3 v = normalize(Vvert);

	if (useParallax) {
        float ht = texture(alturas, TexCoord).x;
        float h = ht * scaleFactor - biasValue;

        vec2 T_ajustada = TexCoord + h * v.xy;

        vec4 c = texture(colores, T_ajustada);
        vec3 n = normalize((texture(normales, T_ajustada).xyz - vec3(0.5, 0.5, 0.5)) * 2.0);
	    vec4 b = texture(brillos, T_ajustada);

        fragColor = iluminacion(c, n, v, l, b.x);

	} else {
        vec4 c = texture(colores, TexCoord);
        vec3 n = normalize((texture(normales, TexCoord).xyz - vec3(0.5, 0.5, 0.5)) * 2.0);
	    vec4 b = texture(brillos, TexCoord);

        fragColor = iluminacion(c, n, v, l, b.x);
	}
}
