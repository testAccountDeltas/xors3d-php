//##########################################
//  Craft - per-pixel block shader
//
//  Soft voxel lighting for the chunk meshes:
//    - half-Lambert directional sun (smooth, no hard terminator)
//    - hemispheric ambient (sky tint from above, ground tint from below)
//    - multiplies the baked vertex colour (ambient occlusion + skylight +
//      torch glow already baked per-vertex by the mesher)
//    - distance fog from the clip-space W (view depth), so no camera pos needed
//    - alpha-test clip so masked glass keeps its see-through holes
//
//  ps_2_0 / vs_2_0 so it runs on old hardware; the game validates the
//  technique and falls back to fixed-function vertex colour if unsupported.
//##########################################

const float4x4 MatWorldViewProj;
const float4x4 MatWorld;

const float3 SunDir;    // normalized direction TO the sun (world space)
const float3 SunClr;    // sun colour * intensity (dim/blue at night)
const float3 SkyAmb;    // hemispheric ambient coming from above
const float3 GndAmb;    // hemispheric ambient coming from below
const float3 FogClr;    // fog / sky colour
const float2 FogRange;  // x = fog start, y = fog end (in view-depth units)

const texture tDiffuse : TEXTURE_0;
sampler S = sampler_state {
    Texture   = <tDiffuse>;
    ADDRESSU  = WRAP;
    ADDRESSV  = WRAP;
    MAGFILTER = POINT;    // crisp pixel-art texels (matches TF_POINT)
    MINFILTER = LINEAR;
    MIPFILTER = LINEAR;
};

struct VIn {
    float4 Pos  : POSITION0;
    float3 Nrm  : NORMAL;
    float2 UV   : TEXCOORD0;
    float2 Emit : TEXCOORD1;   // second uv set: x = torch emissive amount (0..1)
    float4 Col  : COLOR0;
};
struct VOut {
    float4 Pos  : POSITION0;
    float2 UV   : TEXCOORD0;
    float3 Nrm  : TEXCOORD1;
    float  Fog  : TEXCOORD2;
    float  Emit : TEXCOORD3;
    float4 Col  : COLOR0;
};

VOut VS(VIn IN) {
    VOut O;
    O.Pos  = mul(IN.Pos, MatWorldViewProj);
    O.UV   = IN.UV;
    O.Nrm  = normalize(mul(IN.Nrm, (float3x3) MatWorld));
    O.Fog  = O.Pos.w;              // view-space depth
    O.Emit = IN.Emit.x;
    O.Col  = IN.Col;
    return O;
}

float4 PS(VOut IN) : COLOR {
    float4 t = tex2D(S, IN.UV);
    clip(t.a - 0.5);                          // masked transparency (glass holes)

    float3 n = normalize(IN.Nrm);
    float  d = dot(n, SunDir) * 0.5 + 0.5;    // half-Lambert: soft, wraps past 90deg
    d = d * d;                                // gentle contrast
    float  h = n.y * 0.5 + 0.5;               // 1 up, 0 down
    float3 amb = lerp(GndAmb, SkyAmb, h);     // hemispheric fill
    float3 light = amb + SunClr * d;

    float3 col = t.rgb * IN.Col.rgb * light;  // baked AO/skylight * soft day/night light
    // torch/glowstone emission (second uv set): warm light added on top, independent of
    // time of day so building lights stay lit at night.
    col += t.rgb * saturate(IN.Emit) * float3(1.0, 0.80, 0.48) * 2.1;

    float f = saturate((IN.Fog - FogRange.x) / (FogRange.y - FogRange.x));
    col = lerp(col, FogClr, f);
    return float4(col, 1.0);
}

technique Block {
    pass p0 {
        AlphaBlendEnable = false;
        ZEnable          = true;
        CullMode         = None;   // chunk meshes are double-wound already
        vertexshader = compile vs_2_0 VS();
        pixelshader  = compile ps_2_0 PS();
    }
}
