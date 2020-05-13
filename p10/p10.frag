#version 420

$Lights
$Material

uniform sampler2DShadow depthTexture;
uniform sampler2DShadow depthTexture2;

in vec3 N, V;
in vec3 epos;
in vec4 spos;
in vec4 spos2;

out vec4 fragColor;

// Sólo se tiene en cuenta la primera fuente, y se considera que 
// es puntual.
vec4 iluminacion(vec3 pos, vec3 N, vec3 V, float f, float f2) {
  vec4 color = emissive;
  for (int i = 0; i < 2; i++) {
       float factor;
       if(i == 0) {
        factor = f;
       } else {
        factor = f2;
       }
      color += lights[i].ambient * ambient;
      // Vector iluminación (desde vértice a la fuente)
      vec3 L = normalize(vec3(lights[i].positionEye) - pos);
      // Multiplicador de la componente difusa
      float diffuseMult = max(dot(N,L), 0.0);
      float specularMult = 0.0;
      if (diffuseMult > 0.0) {
        // Multiplicador de la componente especular
        vec3 R = reflect(-L, N);
        specularMult = max(0.0, dot(R, V));
        specularMult = pow(specularMult, shininess);
      }
      color += factor * (lights[i].diffuse * diffuse * diffuseMult +
             lights[i].specular * specular * specularMult);
  }
  return color;
}

void main() {
  vec3 nN, nV;
  nN = normalize(N);
  nV = normalize(V);

  float f = textureProj(depthTexture, spos);
  float f2 = textureProj(depthTexture2, spos2);
  fragColor = iluminacion(epos, nN, nV, f, f2);
}
