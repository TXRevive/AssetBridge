Shader "KriptoFX/ME/LightningParticles"
{
  Properties
  {
    [HDR] _TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
    _MainTex ("Main Texture", 2D) = "white" {}
    _DistortTex1 ("Distort Texture1", 2D) = "white" {}
    _DistortTex2 ("Distort Texture2", 2D) = "white" {}
    _DistortSpeed ("Distort Speed Scale (xy/zw)", Vector) = (1,0.1,1,0.1)
    _Offset ("Offset", float) = 0
    _UseVelocity ("UseVelocity", Range(0, 1)) = 0
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "QUEUE" = "Transparent"
      "RenderType" = "Transparent"
    }
    Pass // ind: 1, name: 
    {
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "QUEUE" = "Transparent"
        "RenderType" = "Transparent"
      }
      ZClip Off
      ZWrite Off
      Cull Off
      Blend SrcAlpha One
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      #define conv_mxt4x4_3(mat4x4) float4(mat4x4[0].w,mat4x4[1].w,mat4x4[2].w,mat4x4[3].w)
      
      
      #define CODE_BLOCK_VERTEX
      uniform float _UseVelocity;
      uniform float4 _MainTex_ST;
      uniform float4 _DistortTex1_ST;
      uniform float4 _DistortTex2_ST;
      //uniform float4 _Time;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _TintColor;
      uniform float4 _DistortSpeed;
      uniform float _Offset;
      uniform sampler2D _DistortTex1;
      uniform sampler2D _DistortTex2;
      uniform sampler2D _MainTex;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 color :COLOR;
          float2 texcoord :TEXCOORD0;
          float3 texcoord1 :TEXCOORD1;
      };
      
      struct OUT_Data_Vert
      {
          float4 vertex :SV_POSITION;
          float4 color :COLOR;
          float2 texcoord :TEXCOORD0;
          float texcoord2 :TEXCOORD2;
          float4 texcoord1 :TEXCOORD1;
      };
      
      struct v2f
      {
          float4 vertex :SV_POSITION;
          float4 color :COLOR;
          float2 texcoord :TEXCOORD0;
          float texcoord2 :TEXCOORD2;
          float4 texcoord1 :TEXCOORD1;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float4 u_xlat2;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0 = (in_v.vertex.yyyy * conv_mxt4x4_1(unity_ObjectToWorld));
          u_xlat0 = ((conv_mxt4x4_0(unity_ObjectToWorld) * in_v.vertex.xxxx) + u_xlat0);
          u_xlat0 = ((conv_mxt4x4_2(unity_ObjectToWorld) * in_v.vertex.zzzz) + u_xlat0);
          u_xlat1 = (u_xlat0 + conv_mxt4x4_3(unity_ObjectToWorld));
          u_xlat0.xy = ((conv_mxt4x4_3(unity_ObjectToWorld).xy * in_v.vertex.ww) + u_xlat0.xy);
          out_v.vertex = mul(unity_MatrixVP, u_xlat1);
          out_v.color = in_v.color;
          u_xlat0.z = length(in_v.texcoord1.xyzx);
          u_xlat0.w = ((-u_xlat0.z) + _Time.x);
          out_v.texcoord2.x = ((_DistortTex2_ST.y * u_xlat0.w) + u_xlat0.z);
          out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _DistortTex2);
          out_v.texcoord1.xy = TRANSFORM_TEX(u_xlat0.xy, _DistortTex2);
          out_v.texcoord1.zw = TRANSFORM_TEX(u_xlat0.xy, _DistortTex2);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float4 u_xlat1_d;
      float4 u_xlat2_d;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.x = (_Time.x * 5);
          u_xlat0_d.xy = ((in_f.texcoord.xy * float2(7, 7)) + u_xlat0_d.xx);
          u_xlat0_d = tex2D(_MainTex, u_xlat0_d.xy);
          u_xlat0_d.x = ((-u_xlat0_d.z) + in_f.color.w);
          u_xlat0_d.x = (u_xlat0_d.x<0);
          if((u_xlat0_d.x!=0))
          {
              discard;
          }
          u_xlat0_d = (in_f.texcoord2.xxxx * _Offset.xxzz);
          u_xlat0_d = (((-u_xlat0_d) * float4(1.4, 1.4, 1.25, 1.25)) + in_f.texcoord1);
          u_xlat0_d = (u_xlat0_d + float4(0.4, 0.6, 0.3, 0.7));
          u_xlat1_d = tex2D(_DistortTex2, u_xlat0_d.zw);
          u_xlat0_d = tex2D(_DistortTex1, u_xlat0_d.xy);
          u_xlat0_d.xy = ((u_xlat0_d.xy * float2(2, 2)) + float2(-1, (-1)));
          u_xlat0_d.zw = ((u_xlat1_d.xy * float2(2, 2)) + float2(-1, (-1)));
          u_xlat1_d = ((_Offset.xxzz * in_f.texcoord2.xxxx) + in_f.texcoord1);
          u_xlat2_d = tex2D(_DistortTex2, u_xlat1_d.zw);
          u_xlat1_d = tex2D(_DistortTex1, u_xlat1_d.xy);
          u_xlat1_d.xy = ((u_xlat1_d.xy * float2(2, 2)) + float2(-1, (-1)));
          u_xlat0_d.xy = (u_xlat0_d.xy + u_xlat1_d.xy);
          u_xlat1_d.xy = ((u_xlat2_d.xy * float2(2, 2)) + float2(-1, (-1)));
          u_xlat0_d.zw = (u_xlat0_d.zw + u_xlat1_d.xy);
          u_xlat0_d = (u_xlat0_d * _Offset.yyww);
          u_xlat1_d = tex2D(_MainTex, in_f.texcoord.xy);
          u_xlat1_d.x = saturate((u_xlat1_d.y + _Offset.x));
          u_xlat0_d.xy = ((u_xlat0_d.xy * u_xlat1_d.xx) + in_f.texcoord.xy);
          u_xlat0_d.xy = ((u_xlat0_d.zw * u_xlat1_d.xx) + u_xlat0_d.xy);
          u_xlat0_d = tex2D(_MainTex, u_xlat0_d.xy);
          float _tmp_dvx_1 = (_Offset + _Offset);
          u_xlat1_d = float4(_tmp_dvx_1, _tmp_dvx_1, _tmp_dvx_1, _tmp_dvx_1);
          u_xlat0_d = (u_xlat0_d.xxxx * u_xlat1_d);
          out_f.color = (u_xlat0_d * in_f.color.wwww);
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
