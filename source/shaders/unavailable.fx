struct vertexOutput { 
  float4 Position: POSITION;
  float2 TexCoord: TEXCOORD0;
  float4 Color: COLOR0;
};

sampler2D DiffuseMap: register(s0);
float Radius: register(c1);

float4 std_PS(vertexOutput Input) : COLOR {
  float4 color = tex2D(DiffuseMap, Input.TexCoord);
  float len = length(Input.TexCoord - 0.5f);
  
  float4 output = 0.0f;
  if (len > Radius)
  {
    output = color;
  }
  return output * Input.Color;
}

// Compiler directives
technique main
{
  pass Pass0
  {
    VertexShader = null;
    PixelShader = compile ps_2_0 std_PS();
  }
};
