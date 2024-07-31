//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import Foundation

extension RenderFunctionStrings {
    static func initFunc(variableInitStrings: [String]) -> String {
        
"""
public func setup(targetPixelFormat: MTLPixelFormat) {
"""
        +
        variableInitStrings.reduce("") { r, e in r + e + "\n" }
        +
"""
    let tempFunctionName = "f" + UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
    
    var functionImpl = ""
    functionImpl += Self.initialMetalHeader
    functionImpl += customMetalCode
    
    //vertex
    functionImpl += "vertex RasterizerData \\(tempFunctionName)_vert("
    
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
    functionImpl += "const VertexInput vertexInput [[ stage_in ]]"
    functionImpl += "){"
    functionImpl += "RasterizerData rd;"
    
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
    
    functionImpl += vertImpl
    functionImpl += "return rd;"
    functionImpl += "}"
    
    //fragment
    functionImpl += "fragment float4 \\(tempFunctionName)_frag("
    
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
    functionImpl += "RasterizerData rd [[stage_in]],"
    functionImpl += "float2 pc [[point_coord]],"
    functionImpl += "float4 c0 [[color(0)]]"
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
    
    functionImpl += fragImpl
    functionImpl += "}"
    
    
    let library = try! ShaderCore.device.makeLibrary(
        source: functionImpl,
        options: nil
    )
    let descriptor = MTLRenderPipelineDescriptor()
    descriptor.vertexFunction = library.makeFunction(name: tempFunctionName + "_vert")
    descriptor.fragmentFunction = library.makeFunction(name: tempFunctionName + "_frag")
    
    let vertexDesc = MTLVertexDescriptor()
    for i in 0..<10 {
        vertexDesc.attributes[i].format = .float4
        vertexDesc.attributes[i].offset = MemoryLayout<simd_float4>.stride * i
        vertexDesc.attributes[i].bufferIndex = 0
    }
    vertexDesc.layouts[0].stride = MemoryLayout<simd_float4>.stride * 10
    vertexDesc.layouts[0].stepRate = 1
    vertexDesc.layouts[0].stepFunction = .perVertex
    descriptor.vertexDescriptor = vertexDesc
    descriptor.colorAttachments[0].pixelFormat = targetPixelFormat
    descriptor.colorAttachments[0].isBlendingEnabled = true
    self.renderPipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: descriptor)
}
"""
    }
}
