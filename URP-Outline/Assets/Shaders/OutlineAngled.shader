Shader "Custom/OutlineAngled"
{
    Properties
    {
        _OutlineColor("Outline Color", Color) = (1, 0, 0, 1)
        _OutlineDistance("Outline Distance", Float) = 0.03
    }

    SubShader
    {
        Pass
        {
            Tags
            {
                "RenderType" = "Opaque"
                "RenderPipeline" = "UniversalPipeline"
            }

            Cull Front

            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
            };

            struct Varyings
            {
                float4 positionHCS  : SV_POSITION;
            };

            CBUFFER_START(UnityPerMaterial)
            half4 _OutlineColor;
            half _OutlineDistance;
            CBUFFER_END

            Varyings vert(Attributes IN)
            {
                Varyings OUT;
                
                /* Object space */
                // float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz + IN.normalOS.xyz * _OutlineDistance);
                // OUT.positionHCS = TransformWorldToHClip(positionWS);

                /* World space */
                // float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz);
                // float3 normalWS = TransformObjectToWorldNormal(IN.normalOS.xyz);
                // positionWS += normalWS * _OutlineDistance;
                // OUT.positionHCS = TransformWorldToHClip(positionWS);

                /* World space, constant outline thickness */
                float3 positionWS = TransformObjectToWorld(IN.positionOS.xyz);
                float3 normalWS = TransformObjectToWorldNormal(IN.normalOS.xyz);
                float distToCam = length(_WorldSpaceCameraPos - positionWS);
                positionWS += normalWS * distToCam * _OutlineDistance;
                OUT.positionHCS = TransformWorldToHClip(positionWS);

                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                return _OutlineColor;
            }
            ENDHLSL
        }
    }

    FallBack "Hidden/Universal Render Pipeline/FallbackError"
}
