//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import Foundation

enum Util {
    
    static func typeToArgumentString(type: String, variableName: String) -> String? {
        switch type {
            
        case "Float":
            return ".float(\(variableName))"
        case "Bool":
            return ".bool(\(variableName))"
        case "Int32":
            return ".int(\(variableName))"
            
        case "simd_int2":
            return ".int2(\(variableName))"
        case "simd_int3":
            return ".int3(\(variableName))"
        case "simd_int4":
            return ".int4(\(variableName))"
            
        case "SIMD2<Int32>":
            return ".int2(\(variableName))"
        case "SIMD3<Int32>":
            return ".int3(\(variableName))"
        case "SIMD4<Int32>":
            return ".int4(\(variableName))"
            
        case "simd_float2":
            return ".float2(\(variableName))"
        case "simd_float3":
            return ".float3(\(variableName))"
        case "simd_float4":
            return ".float4(\(variableName))"
            
        case "SIMD2<Float>":
            return ".float2(\(variableName))"
        case "SIMD3<Float>":
            return ".float3(\(variableName))"
        case "SIMD4<Float>":
            return ".float4(\(variableName))"
            
        case "simd_float2x2":
            return ".float2x2(\(variableName))"
        case "simd_float3x3":
            return ".float3x3(\(variableName))"
        case "simd_float4x4":
            return ".float4x4(\(variableName))"
            
        default:
            return nil
        }
    }
    
    static func textureTypeToArgumentString(textureType: String, variableName: String, usage: String) -> String? {
        switch textureType {
        case "MTLTexture?":
            return ".texture2d(\(variableName), \(usage))"
        default:
            return nil
        }
    }
}
