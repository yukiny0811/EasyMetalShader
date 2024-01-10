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
    
    static func getInitialValue(of obj: Any, objTypeString: String) -> EMArgumentCompatible? {
        switch objTypeString {
        case "Swift.Bool":
            return (obj as? EMArgument<Bool>)?.initialValue
        case "Swift.Int32":
            return (obj as? EMArgument<Int32>)?.initialValue
        case "EasyMetalShader.em_int2":
            return (obj as? EMArgument<em_int2>)?.initialValue
        case "EasyMetalShader.em_int3":
            return (obj as? EMArgument<em_int3>)?.initialValue
        case "EasyMetalShader.em_int4":
            return (obj as? EMArgument<em_int4>)?.initialValue
        case "EasyMetalShader.em_float2":
            return (obj as? EMArgument<em_float2>)?.initialValue
        case "EasyMetalShader.em_float3":
            return (obj as? EMArgument<em_float3>)?.initialValue
        case "EasyMetalShader.em_float4":
            return (obj as? EMArgument<em_float4>)?.initialValue
        case "EasyMetalShader.em_float2x2":
            return (obj as? EMArgument<em_float2x2>)?.initialValue
        case "EasyMetalShader.em_float3x3":
            return (obj as? EMArgument<em_float3x3>)?.initialValue
        case "EasyMetalShader.em_float4x4":
            return (obj as? EMArgument<em_float4x4>)?.initialValue
        case "Swift.Float":
            return (obj as? EMArgument<Float>)?.initialValue
        case "EasyMetalShader.EMMetalTexture":
            return (obj as? EMArgument<EMMetalTexture>)?.initialValue
        default:
            return nil
        }
    }
    
    static func getMetalArgument<Value>(from instance: Value) -> EMMetalArgument? {
        switch instance {
        case is Float:
            return .float(instance as! Float)
        case is Bool:
            return .bool(instance as! Bool)
        case is Int32:
            return .int(instance as! Int32)
        case is em_int2:
            let i = instance as! em_int2
            return .int2(i.simdValue)
        case is em_int3:
            let i = instance as! em_int3
            return .int3(i.simdValue)
        case is em_int4:
            let i = instance as! em_int4
            return .int4(i.simdValue)
        case is em_float2:
            let i = instance as! em_float2
            return .float2(i.simdValue)
        case is em_float3:
            let i = instance as! em_float3
            return .float3(i.simdValue)
        case is em_float4:
            let i = instance as! em_float4
            return .float4(i.simdValue)
        case is em_float2x2:
            let i = instance as! em_float2x2
            return .float2x2(i.simdValue)
        case is em_float3x3:
            let i = instance as! em_float3x3
            return .float3x3(i.simdValue)
        case is em_float4x4:
            let i = instance as! em_float4x4
            return .float4x4(i.simdValue)
        case is EMMetalTexture:
            let i = instance as! EMMetalTexture
            return .texture2d(i.texture, i.usage)
        default:
            return nil
        }
    }
}
