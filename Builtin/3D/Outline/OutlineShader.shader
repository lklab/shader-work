Shader "Custom/Outline"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        _OutlineWidth ("Outline width", Range(0,1)) = 0.0
        _OutlineColor ("Outline color", Color) = (1,1,1,1)

        _StencilComp ("Stencil Comparison", Float) = 7
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 32
        _StencilReadMask ("Stencil Read Mask", Float) = 50
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "Queue"="Overlay"
        }

        Stencil
        {
            Ref 0
            Comp Equal
        }

        LOD 200
        Cull front
        ZTest Always

        pass
        {
            CGPROGRAM
            #include "UnityCG.cginc"
            #pragma vertex vertLine
            #pragma fragment fragLine
            #pragma target 3.0

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float3 color : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float3 vertexColor : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            sampler2D _MainTex;
            float _OutlineWidth;
            float4 _OutlineColor;

            v2f vertLine(appdata_full v)
            {
                v2f o;
                o.vertexColor = v.color;
                o.texcoord = v.texcoord;
                o.normal = v.normal;

                o.vertex = UnityObjectToClipPos(v.vertex + v.normal * 0.05);

                return o;
            }

            fixed4 fragLine(v2f i) : SV_Target
            {
                float4 col;
                col.a = 1;
                return col;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}
