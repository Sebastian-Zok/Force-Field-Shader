Shader "Custom/ForceField" {
    Properties{
        _MainTex("Texture", 2D) = "white" {}
        _MinDistance("Minimum Distance", float) = 3
        _MaxDistance("Maximum Distance", float) = 100
    }
        SubShader{
            Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
            LOD 200
            ZWrite Off
            ZTest Less
            Cull Off

            CGPROGRAM
            #pragma surface surf Lambert alpha


            sampler2D _MainTex;
            float _MinDistance;
            float _MaxDistance;

            struct Input {
                float2 uv_MainTex;
                float3 worldPos;
            };

            void surf(Input IN, inout SurfaceOutput o) {
                half4 c = tex2D(_MainTex, IN.uv_MainTex);
                o.Albedo = c;
                o.Alpha = 0;
                float dist = distance(IN.worldPos, _WorldSpaceCameraPos);
                if (dist < _MaxDistance) {
                    o.Albedo = c.rgb;
                    dist = dist - _MinDistance;
                    float f = _MaxDistance - _MinDistance;
                    float p = dist / f;
                    float cl = lerp(1, 0, p);
                    cl = min(1, cl);
                    cl = max(0, cl);
                    o.Alpha = tex2D(_MainTex, IN.uv_MainTex).a * cl;
                }
            }
            ENDCG
        }
            FallBack "Diffuse"
}