// This file is generated. Do not edit it manually. Please edit .shaderproto files.

Shader "Nova/Post Processing/Colorless"
{
    Properties
    {
        [HideInInspector] _MainTex ("Main Texture", 2D) = "white" {}
        _T ("Time", Range(0.0, 1.0)) = 0.0
    }
    SubShader
    {
        Cull Off ZWrite Off ZTest Always
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Assets/Nova/CGInc/Rand.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 color : COLOR;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;
                return o;
            }

            sampler2D _MainTex;
            float _T;

            fixed4 frag(v2f i) : SV_Target
            {
                float4 col = tex2D(_MainTex, i.uv);

                float2 v = 0.001 * snoise2(float3(i.uv * 10.0, _Time.y));
                float gray = Luminance(col.rgb);
                float mask = gray * gray;
                mask = 2.0 * mask * mask * _T;
                v *= mask;

                col.r = tex2D(_MainTex, i.uv + v).r;
                col.g = tex2D(_MainTex, i.uv - v).g;

                col *= i.color;

                return col;
            }
            ENDCG
        }
    }
}
