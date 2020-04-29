#version 420 core

in TESE_OUT {
	vec2 textureCoord;
};

uniform	sampler1D texUnitColorScale;
uniform	sampler2D texUnitHeightMap;
out vec4 finalColor;


void main() {
	finalColor = texture(texUnitColorScale, min(0.99, texture(texUnitHeightMap, textureCoord).r)); 
}
