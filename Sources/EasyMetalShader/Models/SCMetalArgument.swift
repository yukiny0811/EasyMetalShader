//
//  SCMetalArgument.swift
//
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import simd
import MetalKit

public enum SCMetalArgument {
    
    case bool(Bool)
    case int(Int32)
    case int2(simd_int2)
    case int3(simd_int3)
    case int4(simd_int4)
    case float(Float)
    case float2(simd_float2)
    case float3(simd_float3)
    case float4(simd_float4)
    case texture2d(MTLTexture!, SCMetalTextureUsage)
    
    static func getInitialValue(of obj: Any, objTypeString: String) -> SCArgumentCompatible? {
        switch objTypeString {
        case "Swift.Bool":
            return (obj as? EMArgument<Bool>)?.initialValue
        case "Swift.Int":
            return (obj as? EMArgument<Int>)?.initialValue
        case "EasyMetalShader.sc_int2":
            return (obj as? EMArgument<sc_int2>)?.initialValue
        case "EasyMetalShader.sc_int3":
            return (obj as? EMArgument<sc_int3>)?.initialValue
        case "EasyMetalShader.sc_int4":
            return (obj as? EMArgument<sc_int4>)?.initialValue
        case "EasyMetalShader.sc_float2":
            return (obj as? EMArgument<sc_float2>)?.initialValue
        case "EasyMetalShader.sc_float3":
            return (obj as? EMArgument<sc_float3>)?.initialValue
        case "EasyMetalShader.sc_float4":
            return (obj as? EMArgument<sc_float4>)?.initialValue
        case "Swift.Float":
            return (obj as? EMArgument<Float>)?.initialValue
        case "EasyMetalShader.SCMetalTexture":
            return (obj as? EMArgument<SCMetalTexture>)?.initialValue
        default:
            return nil
        }
    }
    
    static func getMetalArgument<Value>(from instance: Value) -> SCMetalArgument? {
        switch instance {
        case is Float:
            return .float(instance as! Float)
        case is Bool:
            return .bool(instance as! Bool)
        case is Int32:
            return .int(instance as! Int32)
        case is sc_int2:
            let i = instance as! sc_int2
            return .int2(simd_int2(i.x, i.y))
        case is sc_int3:
            let i = instance as! sc_int3
            return .int3(simd_int3(i.x, i.y, i.z))
        case is sc_int4:
            let i = instance as! sc_int4
            return .int4(simd_int4(i.x, i.y, i.z, i.w))
        case is sc_float2:
            let i = instance as! sc_float2
            return .float2(simd_float2(i.x, i.y))
        case is sc_float3:
            let i = instance as! sc_float3
            return .float3(simd_float3(i.x, i.y, i.z))
        case is sc_float4:
            let i = instance as! sc_float4
            return .float4(simd_float4(i.x, i.y, i.z, i.w))
        case is SCMetalTexture:
            let i = instance as! SCMetalTexture
            return .texture2d(i.texture, i.usage)
        default:
            return nil
        }
    }
}
