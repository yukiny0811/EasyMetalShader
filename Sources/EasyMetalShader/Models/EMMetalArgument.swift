//
//  EMMetalArgument.swift
//
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import simd
import MetalKit

public enum EMMetalArgument {
    
    case bool(Bool)
    case int(Int32)
    case int2(simd_int2)
    case int3(simd_int3)
    case int4(simd_int4)
    case float(Float)
    case float2(simd_float2)
    case float3(simd_float3)
    case float4(simd_float4)
    case float2x2(simd_float2x2)
    case float3x3(simd_float3x3)
    case float4x4(simd_float4x4)
    case texture2d(MTLTexture!, EMMetalTextureUsage)
    case texture3d(MTLTexture!, EMMetalTextureUsage)
    case boolBuffer(BoolBuffer)
    case intBuffer(IntBuffer)
    case int2Buffer(Int2Buffer)
    case int3Buffer(Int3Buffer)
    case int4Buffer(Int4Buffer)
    case floatBuffer(FloatBuffer)
    case float2Buffer(Float2Buffer)
    case float3Buffer(Float3Buffer)
    case float4Buffer(Float4Buffer)
    case doubleBuffer(DoubleBuffer)
    case double2Buffer(Double2Buffer)
    case double3Buffer(Double3Buffer)
    case double4Buffer(Double4Buffer)

}
