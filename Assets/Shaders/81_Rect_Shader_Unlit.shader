Shader "Unlit/81_Rect_Shader_Unlit"
{
    Properties
    {
        _CenterX("Center X", Range(-0.5, 0.5)) = 0
        _CenterY("Center Y", Range(-0.5, 0.5)) = 0
        _Width("Width", Range(0.0, 1.0)) = 0.5
        _Height("Height", Range(0.0, 1.0)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            float _CenterX;
            float _CenterY;
            float _Width;
            float _Height;

            struct v2f
            {
                // Cg Semantics
                //      Binds Shader input/output to rendering hardware
                //      - SV_POSITION means system value position in DX10, corresponds to vertex position
                //      - TEXCOORDn means custom data

                float4 vertex: SV_POSITION; // From Object-Space to Clip-Space
                float4 position: TEXCOORD1;
                float4 uv: TEXCOORD0;
            };

            v2f vert (appdata_base v)
            {
                v2f output;

                output.vertex = UnityObjectToClipPos(v.vertex);
                output.position = v.vertex;
                output.uv = v.texcoord;

                return output;
            }

            float checkInRect(float2 position, float2 center, float2 size)
            {
                // returns 1 when the position is inside the rect defined by center and size
                float2 p = position - center;

                float2 halfSize = size * 0.5;

                // 0 if less than -halfSize, 1 if between -halfSize and halfSize, 0 if over halfSize
                float2 test = step(-halfSize, p) - step(halfSize, p);

                return test.x * test.y;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 position = i.position.xy;
                fixed inRect = checkInRect(position, float2(_CenterX, _CenterY), float2(_Width, _Height));

                return fixed4(1,1,1,1) * inRect;
            }
            ENDCG
        }
    }
}
