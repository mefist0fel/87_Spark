struct vertexOutput { 
  float4 Position: POSITION;
  float2 TexCoord: TEXCOORD0;
  float4 Color: COLOR0;
};

sampler2D DiffuseMap: register(s0);
float2 Radius: register(c1); //inner - outer
float4 Angle: register(c2); //yel - gren - blue - red
float4 ColorY: register(c3);
float4 ColorG: register(c4);
float4 ColorB: register(c5);
float4 ColorR: register(c6);

float4 std_PS(vertexOutput Input) : COLOR {
  float4 color = tex2D(DiffuseMap, Input.TexCoord);
  float2 pos = (Input.TexCoord - 0.5f);
  float2 dir = normalize(pos);  
  float len = length(pos);
  
  float4 output = 0.0f;
  if (len < Radius.y)
  {
    if (len > Radius.x)
    {
      float angle = acos(dir.x);
      if (asin(dir.y) < 0)
      {
        angle = 6.283185307 - angle;
      }
    
      if (angle < Angle.x)
      {
        color = ColorY;
      }
      else if (angle < Angle.y)
      {
        color = ColorG;
      }
      else if (angle < Angle.z)
      {
        color = ColorB;
      }
      else if (angle < Angle.w)
      {
        color = ColorR;
      }
    }
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
