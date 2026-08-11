//#####################################################################
// GodRays.fx - screen-space light shafts (radial god rays) for Craft.
// Marches from each pixel toward the sun's screen position, accumulating
// bright (sky/sun) pixels with decay -> volumetric-looking sun rays.
//#####################################################################

const float4x4 MatWorldViewProj;

const texture tScene;
sampler Scene = sampler_state {
    Texture   = <tScene>;
    AddressU  = Clamp;
    AddressV  = Clamp;
    MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = None;
};

float2 SunUV      = float2(0.5, 0.5); // sun position in screen UV
float3 RayColor   = float3(1.0, 0.9, 0.6);
float  Density    = 0.9;
float  Decay      = 0.96;
float  Weight     = 0.5;
float  Threshold  = 0.7;

struct VSin  { float4 Position : POSITION0; float2 T : TEXCOORD0; };
struct VSout { float4 Position : POSITION0; float2 T : TEXCOORD0; };

void vs(in VSin IN, out VSout OUT)
{
    OUT.Position = mul(IN.Position, MatWorldViewProj);
    OUT.T        = IN.T;
}

#define NUM_SAMPLES 24

float4 ps(in VSout IN) : COLOR
{
    float2 uv    = IN.T;
    float2 delta = (uv - SunUV) * (Density / NUM_SAMPLES);
    float2 coord = uv;
    float  illum = 1.0;
    float  shaft = 0.0;

    for (int i = 0; i < NUM_SAMPLES; i++)
    {
        coord -= delta;                       // step toward the sun
        float3 s   = tex2D(Scene, coord).rgb;
        float  lum = dot(s, float3(0.299, 0.587, 0.114));
        lum = saturate((lum - Threshold) * 4.0);   // bright pass
        shaft += lum * illum;
        illum *= Decay;
    }
    shaft *= Weight / NUM_SAMPLES;

    float3 scene = tex2D(Scene, uv).rgb;
    return float4(scene + shaft * RayColor, 1.0);
}

technique Rays
{
    pass p0
    {
        vertexshader = compile vs_3_0 vs();
        pixelshader  = compile ps_3_0 ps();
    }
}
