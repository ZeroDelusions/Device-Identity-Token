//
//  CRTEffect.metal
//  DeviceIdentityToken
//
//  Created by Косоруков Дмитро on 05/07/2024.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI.h>
using namespace metal;

float2 distort(float2 uv, float strength) {
    float2 dist = 0.5 - uv;
    uv.x = (uv.x - dist.y * dist.y * dist.x * strength);
    uv.y = (uv.y - dist.x * dist.x * dist.y * strength);
    return uv;
}

half4 blur(SwiftUI::Layer layer, float2 uv, float2 size, float radius) {
    half4 color = half4(0.0);
    int samples = 0;
    float2 tex_offset = 1.0 / size; // texture coordinate offset

    for (int x = -4; x <= 4; ++x) { // Increase range for stronger blur
        for (int y = -4; y <= 4; ++y) {
            float2 offset = float2(x, y) * tex_offset * radius;
            color += layer.sample(uv + offset);
            samples++;
        }
    }
    return color / samples;
}

//float random(float2 st, float seed) {
//    return fract(sin(dot(st.xy, float2(12.9898, 78.233)) + seed) * 43758.5453123);
//}

float random(float2 st, float seed) {
    float value = sin(dot(st.xy, float2(12.9898, 78.233)) + seed);
    return fract(value * 43758.5453123);
}


[[stitchable]] half4 noise(float2 position, half4 currentColor, float time) {
    float2 st = position / 4.0; // Adjust scale as needed
    float2 ipos = floor(st);
    
    // Generate noise value
    float noise = random(ipos, time * 0.1);
    
    // Smooth the transition
    noise = smoothstep(0.0, 1, noise); // Adjust range for darker grays
    
    // Mix with dark gray for smoother appearance
    float3 color = mix(float3(0.04), float3(0.08), noise);
    
    return half4(color.r, color.g, color.b, 1.0) * currentColor.a;
}
