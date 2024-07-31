//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import Foundation

extension ComputeFunctionStrings {
    static func initFunc(variableInitStrings: [String], gidTypeString: String) -> String {
"""
public func setup() {
"""
+
        variableInitStrings.reduce("") { r, e in r + e + "\n" }
+
"""

    let tempFunctionName = "f" + UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")

    var functionImpl = ""
    functionImpl += Self.initialMetalHeader
    functionImpl += customMetalCode
    functionImpl += "kernel void \\(tempFunctionName)("

    for (i, key) in args.keys.enumerated() {
        switch args[key] {
        case .bool(_):
            functionImpl += "device const bool* \\(key)_buf [[buffer(\\(i+1))]]"
        case .int(_):
            functionImpl += "device const int* \\(key)_buf [[buffer(\\(i+1))]]"
        case .int2(_):
            functionImpl += "device const int2* \\(key)_buf [[buffer(\\(i+1))]]"
        case .int3(_):
            functionImpl += "device const int3* \\(key)_buf [[buffer(\\(i+1))]]"
        case .int4(_):
            functionImpl += "device const int4* \\(key)_buf [[buffer(\\(i+1))]]"
        case .float(_):
            functionImpl += "device const float* \\(key)_buf [[buffer(\\(i+1))]]"
        case .float2(_):
            functionImpl += "device const float2* \\(key)_buf [[buffer(\\(i+1))]]"
        case .float3(_):
            functionImpl += "device const float3* \\(key)_buf [[buffer(\\(i+1))]]"
        case .float4(_):
            functionImpl += "device const float4* \\(key)_buf [[buffer(\\(i+1))]]"
        case .float2x2(_):
            functionImpl += "device const float2x2* \\(key)_buf [[buffer(\\(i+1))]]"
        case .float3x3(_):
            functionImpl += "device const float3x3* \\(key)_buf [[buffer(\\(i+1))]]"
        case .float4x4(_):
            functionImpl += "device const float4x4* \\(key)_buf [[buffer(\\(i+1))]]"
        case .texture2d(_, let usage):
            switch usage {
            case .read:
                functionImpl += "texture2d<float, access::read> \\(key) [[texture(\\(i+1))]]"
            case .write:
                functionImpl += "texture2d<float, access::write> \\(key) [[texture(\\(i+1))]]"
            case .read_write:
                functionImpl += "texture2d<float, access::read_write> \\(key) [[texture(\\(i+1))]]"
            case .sample:
                functionImpl += "texture2d<float, access::sample> \\(key) [[texture(\\(i+1))]]"
            }
        case .texture3d(_, let usage):
            switch usage {
            case .read:
                functionImpl += "texture3d<float, access::read> \\(key) [[texture(\\(i+1))]]"
            case .write:
                functionImpl += "texture3d<float, access::write> \\(key) [[texture(\\(i+1))]]"
            case .read_write:
                functionImpl += "texture3d<float, access::read_write> \\(key) [[texture(\\(i+1))]]"
            case .sample:
                functionImpl += "texture3d<float, access::sample> \\(key) [[texture(\\(i+1))]]"
            }
        case .boolBuffer(_):
            functionImpl += "device bool* \\(key) [[buffer(\\(i+1))]]"
        case .intBuffer(_):
            functionImpl += "device int* \\(key) [[buffer(\\(i+1))]]"
        case .int2Buffer(_):
            functionImpl += "device int2* \\(key) [[buffer(\\(i+1))]]"
        case .int3Buffer(_):
            functionImpl += "device int3* \\(key) [[buffer(\\(i+1))]]"
        case .int4Buffer(_):
            functionImpl += "device int4* \\(key) [[buffer(\\(i+1))]]"
        case .floatBuffer(_):
            functionImpl += "device float* \\(key) [[buffer(\\(i+1))]]"
        case .float2Buffer(_):
            functionImpl += "device float2* \\(key) [[buffer(\\(i+1))]]"
        case .float3Buffer(_):
            functionImpl += "device float3* \\(key) [[buffer(\\(i+1))]]"
        case .float4Buffer(_):
            functionImpl += "device float4* \\(key) [[buffer(\\(i+1))]]"
        case .doubleBuffer(_):
            functionImpl += "device double* \\(key) [[buffer(\\(i+1))]]"
        case .double2Buffer(_):
            functionImpl += "device double2* \\(key) [[buffer(\\(i+1))]]"
        case .double3Buffer(_):
            functionImpl += "device double3* \\(key) [[buffer(\\(i+1))]]"
        case .double4Buffer(_):
            functionImpl += "device double4* \\(key) [[buffer(\\(i+1))]]"
        case .none:
            break
        }
        functionImpl += ","
    }
    functionImpl += "\(gidTypeString) gid [[thread_position_in_grid]]"
    functionImpl += "){"

    for key in args.keys {
        switch args[key] {
        case .bool(_):
            functionImpl += "bool \\(key) = \\(key)_buf[0];"
        case .int(_):
            functionImpl += "int \\(key) = \\(key)_buf[0];"
        case .int2(_):
            functionImpl += "int2 \\(key) = \\(key)_buf[0];"
        case .int3(_):
            functionImpl += "int3 \\(key) = \\(key)_buf[0];"
        case .int4(_):
            functionImpl += "int4 \\(key) = \\(key)_buf[0];"
        case .float(_):
            functionImpl += "float \\(key) = \\(key)_buf[0];"
        case .float2(_):
            functionImpl += "float2 \\(key) = \\(key)_buf[0];"
        case .float3(_):
            functionImpl += "float3 \\(key) = \\(key)_buf[0];"
        case .float4(_):
            functionImpl += "float4 \\(key) = \\(key)_buf[0];"
        case .float2x2(_):
            functionImpl += "float2x2 \\(key) = \\(key)_buf[0];"
        case .float3x3(_):
            functionImpl += "float3x3 \\(key) = \\(key)_buf[0];"
        case .float4x4(_):
            functionImpl += "float4x4 \\(key) = \\(key)_buf[0];"
        case .texture2d(_, _):
            break
        case .texture3d(_, _):
            break
        case .none:
            break
        default:
            break
        }
    }

    functionImpl += impl
    functionImpl += "}"

    let library = try! ShaderCore.device.makeLibrary(
        source: functionImpl,
        options: nil
    )
    self.computePipelineState = try! ShaderCore.device.makeComputePipelineState(
        function: library.makeFunction(
            name: tempFunctionName
        )!
    )
}
"""
    }
}
