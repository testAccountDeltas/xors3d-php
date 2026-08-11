// view * projection matrix
float4x4 viewProjMatrix : MATRIX_VIEWPROJ;

// texture matrix
float4x4 textureMatrix : MATRIX_TEXTURE0;

// entity diffuse texture
texture diffuseTexture : TEXTURE_0;

// texture filtering
int filtering       : TEXTURE_FILTERING;
int anisotropyLevel : ANISOTROPY_LEVEL;

// light data
float4 ambientColor   : COLOR_AMBIENT;

// Input VS structure
struct VSInput
{
   float4 position  : POSITION0;
   float4 matrixC1  : TEXCOORD2;
   float4 matrixC2  : TEXCOORD3;
   float4 matrixC3  : TEXCOORD4;
   float4 diffColor	: TEXCOORD5;
};

// Output VS structure
struct VSOutput
{
	float4 position  : POSITION0;
	float4 diffColor : TEXCOORD0;
};

// Vertex shader for hardware instancing
void VSMain(in VSInput IN, out VSOutput OUT)
{
	// restore world matrix for instance
	float4x4 worldMatrix;
	worldMatrix[0] = float4(IN.matrixC1.x, IN.matrixC2.x, IN.matrixC3.x, 0.0f);
	worldMatrix[1] = float4(IN.matrixC1.y, IN.matrixC2.y, IN.matrixC3.y, 0.0f);
	worldMatrix[2] = float4(IN.matrixC1.z, IN.matrixC2.z, IN.matrixC3.z, 0.0f);
	worldMatrix[3] = float4(IN.matrixC1.w, IN.matrixC2.w, IN.matrixC3.w, 1.0f);
	// transform position
	OUT.position  = mul(IN.position,  worldMatrix);
	OUT.position  = mul(OUT.position, viewProjMatrix);
	OUT.diffColor = IN.diffColor;
}

// Pixel shaders
float4 PSMain(in VSOutput IN) : COLOR
{
	float4 result  = ambientColor * IN.diffColor;
	return float4(result.xyz, 1.0);
}

//  Techniques
technique Instancing
{
	pass p0
	{
		AlphaTestEnable  = 0;
		CullMode         = CCW;
		VertexShader     = compile vs_2_0 VSMain();
		PixelShader      = compile ps_2_0 PSMain();
	}
}