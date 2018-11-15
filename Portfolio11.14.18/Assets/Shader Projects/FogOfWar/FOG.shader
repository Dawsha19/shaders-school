Shader "Custom/FOG" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Discovered (RGB)", 2D) = "white" {}
		_SecTex("Present (RGB)", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags{ "RenderType" = "Transparent" "LightMode" = "ForwardBase" }
		Blend SrcAlpha OneMinusSrcAlpha //defines how transparency behaves
		Lighting Off
		LOD 200

		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types      //the type of lighting you want to use
		#pragma surface surf Lambert fullforwardshadows alpha:fade // <- turns on transparency

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0 //what verstion of cg you want to use, the higher the target the more features or depreciated

		sampler2D _MainTex;
		sampler2D _SecTex;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SecTex;
		};

		half _Glossiness;
		half _Metallic;
		fixed4 _Color;

		// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
		// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
		// #pragma instancing_options assumeuniformscaling
		UNITY_INSTANCING_BUFFER_START(Props)
			// put more per-instance properties here
		UNITY_INSTANCING_BUFFER_END(Props)

		void surf (Input i, inout SurfaceOutput o) { //where the logic actually happens
			// Albedo comes from a texture tinted by color
			// fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			fixed4 b = tex2D(_SecTex, i.uv_MainTex) * _Color;
			///////////////////////////////////////////////////////
			float blurAmount = .0035;

			fixed4 c = fixed4(0, 0, 0, 0);

			c += tex2D(_MainTex, float2(i.uv_MainTex.x - 5.0 * blurAmount, i.uv_MainTex.y)) * 0.0125;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x - 4.0 * blurAmount, i.uv_MainTex.y)) * 0.025;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x - 3.0 * blurAmount, i.uv_MainTex.y)) * 0.045;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x - 2.0 * blurAmount, i.uv_MainTex.y)) * 0.06;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x - blurAmount, i.uv_MainTex.y)) * 0.07;

			c += tex2D(_MainTex, float2(i.uv_MainTex.x, i.uv_MainTex.y)) * 0.07;

			c += tex2D(_MainTex, float2(i.uv_MainTex.x + blurAmount, i.uv_MainTex.y)) * 0.07;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x + 2.0 * blurAmount, i.uv_MainTex.y)) * 0.06;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x + 3.0 * blurAmount, i.uv_MainTex.y)) * 0.045;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x + 4.0 * blurAmount, i.uv_MainTex.y)) * 0.025;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x + 5.0 * blurAmount, i.uv_MainTex.y)) * 0.0125;

			c += tex2D(_MainTex, float2(i.uv_MainTex.x, i.uv_MainTex.y - 5.0 * blurAmount)) * 0.0125;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x, i.uv_MainTex.y - 4.0 * blurAmount)) * 0.025;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x, i.uv_MainTex.y - 3.0 * blurAmount)) * 0.045;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x, i.uv_MainTex.y - 2.0 * blurAmount)) * 0.06;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x, i.uv_MainTex.y - blurAmount)) * 0.07;

			c += tex2D(_MainTex, float2(i.uv_MainTex.x, i.uv_MainTex.y)) * 0.07;

			c += tex2D(_MainTex, float2(i.uv_MainTex.x, i.uv_MainTex.y + blurAmount)) * 0.07;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x, i.uv_MainTex.y + 2.0 * blurAmount)) * 0.06;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x, i.uv_MainTex.y + 3.0 * blurAmount)) * 0.045;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x, i.uv_MainTex.y + 4.0 * blurAmount)) * 0.025;
			c += tex2D(_MainTex, float2(i.uv_MainTex.x, i.uv_MainTex.y + 5.0 * blurAmount)) * 0.0125;
			//////////////////////////////////////////////////////////

			o.Albedo = 0; //c.rgb;
			// Metallic and smoothness come from slider variables
			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
			o.Alpha = 1 - (c.g * 0.5f) - (b.g * 0.5f);	
		}
		ENDCG
	}
	FallBack "Diffuse"
}
