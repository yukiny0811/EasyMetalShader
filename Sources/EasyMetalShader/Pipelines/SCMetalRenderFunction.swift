//
//  SCMetalRenderFunction.swift
//
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import MetalKit
import simd

open class SCMetalRenderFunction {
    private static let initialMetalHeader = MetalPreLibrary.include + MetalPreLibrary.rand + MetalPreLibrary.svd + MetalPreLibrary.rasterizerData
    
    private var args: [String: SCMetalArgument]
    
    let renderPipelineState: MTLRenderPipelineState
    
    var renderTargetTexture: MTLTexture!
    var needsClear: Bool = false
    
    public init(functionName: String, args: [String: SCMetalArgument], vertImpl: [String], fragImpl: [String], targetPixelFormat: MTLPixelFormat) {
        self.args = args
        
        var functionImpl = ""
        functionImpl += Self.initialMetalHeader
        
        //vertex
        functionImpl += "vertex RasterizerData \(functionName)_vert("
        
        for (i, key) in args.keys.enumerated() {
            switch args[key] {
            case .bool(_):
                functionImpl += "device const bool* \(key)_buf [[buffer(\(i+1))]]"
            case .int(_):
                functionImpl += "device const int* \(key)_buf [[buffer(\(i+1))]]"
            case .int2(_):
                functionImpl += "device const int2* \(key)_buf [[buffer(\(i+1))]]"
            case .int3(_):
                functionImpl += "device const int3* \(key)_buf [[buffer(\(i+1))]]"
            case .int4(_):
                functionImpl += "device const int4* \(key)_buf [[buffer(\(i+1))]]"
            case .float(_):
                functionImpl += "device const float* \(key)_buf [[buffer(\(i+1))]]"
            case .float2(_):
                functionImpl += "device const float2* \(key)_buf [[buffer(\(i+1))]]"
            case .float3(_):
                functionImpl += "device const float3* \(key)_buf [[buffer(\(i+1))]]"
            case .float4(_):
                functionImpl += "device const float4* \(key)_buf [[buffer(\(i+1))]]"
            case .texture2d(_, let usage):
                switch usage {
                case .read:
                    functionImpl += "texture2d<float, access::read> \(key) [[texture(\(i+1))]]"
                case .write:
                    functionImpl += "texture2d<float, access::write> \(key) [[texture(\(i+1))]]"
                case .read_write:
                    functionImpl += "texture2d<float, access::read_write> \(key) [[texture(\(i+1))]]"
                }
            case .none:
                break
            }
            functionImpl += ","
        }
        functionImpl += "const float4 input [[ stage_in attribute(0) ]]"
        functionImpl += "){"
        functionImpl += "RasterizerData rd;"
        
        for key in args.keys {
            switch args[key] {
            case .bool(_):
                functionImpl += "bool \(key) = \(key)_buf[0];"
            case .int(_):
                functionImpl += "int \(key) = \(key)_buf[0];"
            case .int2(_):
                functionImpl += "int2 \(key) = \(key)_buf[0];"
            case .int3(_):
                functionImpl += "int3 \(key) = \(key)_buf[0];"
            case .int4(_):
                functionImpl += "int4 \(key) = \(key)_buf[0];"
            case .float(_):
                functionImpl += "float \(key) = \(key)_buf[0];"
            case .float2(_):
                functionImpl += "float2 \(key) = \(key)_buf[0];"
            case .float3(_):
                functionImpl += "float3 \(key) = \(key)_buf[0];"
            case .float4(_):
                functionImpl += "float4 \(key) = \(key)_buf[0];"
            case .texture2d(_, _):
                break
            case .none:
                break
            }
        }
        
        functionImpl += vertImpl.joined()
        functionImpl += "return rd;"
        functionImpl += "}"
        
        //fragment
        functionImpl += "fragment float4 \(functionName)_frag("
        
        for (i, key) in args.keys.enumerated() {
            switch args[key] {
            case .bool(_):
                functionImpl += "device const bool* \(key)_buf [[buffer(\(i+1))]]"
            case .int(_):
                functionImpl += "device const int* \(key)_buf [[buffer(\(i+1))]]"
            case .int2(_):
                functionImpl += "device const int2* \(key)_buf [[buffer(\(i+1))]]"
            case .int3(_):
                functionImpl += "device const int3* \(key)_buf [[buffer(\(i+1))]]"
            case .int4(_):
                functionImpl += "device const int4* \(key)_buf [[buffer(\(i+1))]]"
            case .float(_):
                functionImpl += "device const float* \(key)_buf [[buffer(\(i+1))]]"
            case .float2(_):
                functionImpl += "device const float2* \(key)_buf [[buffer(\(i+1))]]"
            case .float3(_):
                functionImpl += "device const float3* \(key)_buf [[buffer(\(i+1))]]"
            case .float4(_):
                functionImpl += "device const float4* \(key)_buf [[buffer(\(i+1))]]"
            case .texture2d(_, let usage):
                switch usage {
                case .read:
                    functionImpl += "texture2d<float, access::read> \(key) [[texture(\(i+1))]]"
                case .write:
                    functionImpl += "texture2d<float, access::write> \(key) [[texture(\(i+1))]]"
                case .read_write:
                    functionImpl += "texture2d<float, access::read_write> \(key) [[texture(\(i+1))]]"
                }
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
                functionImpl += "bool \(key) = \(key)_buf[0];"
            case .int(_):
                functionImpl += "int \(key) = \(key)_buf[0];"
            case .int2(_):
                functionImpl += "int2 \(key) = \(key)_buf[0];"
            case .int3(_):
                functionImpl += "int3 \(key) = \(key)_buf[0];"
            case .int4(_):
                functionImpl += "int4 \(key) = \(key)_buf[0];"
            case .float(_):
                functionImpl += "float \(key) = \(key)_buf[0];"
            case .float2(_):
                functionImpl += "float2 \(key) = \(key)_buf[0];"
            case .float3(_):
                functionImpl += "float3 \(key) = \(key)_buf[0];"
            case .float4(_):
                functionImpl += "float4 \(key) = \(key)_buf[0];"
            case .texture2d(_, _):
                break
            case .none:
                break
            }
        }
        
        functionImpl += fragImpl.joined()
        functionImpl += "}"
        
        
        let library = try! ShaderCore.device.makeLibrary(
            source: functionImpl,
            options: nil
        )
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: functionName + "_vert")
        descriptor.fragmentFunction = library.makeFunction(name: functionName + "_frag")
        
        let vertexDesc = MTLVertexDescriptor()
        vertexDesc.attributes[0].format = .float4
        vertexDesc.attributes[0].offset = 0
        vertexDesc.attributes[0].bufferIndex = 0
        vertexDesc.layouts[0].stride = MemoryLayout<simd_float4>.stride
        vertexDesc.layouts[0].stepRate = 1
        vertexDesc.layouts[0].stepFunction = .perVertex
        descriptor.vertexDescriptor = vertexDesc
        descriptor.colorAttachments[0].pixelFormat = targetPixelFormat
        descriptor.colorAttachments[0].isBlendingEnabled = true
        self.renderPipelineState = try! ShaderCore.device.makeRenderPipelineState(descriptor: descriptor)
    }
    
    open func setVariables(args: inout [String: SCMetalArgument]) {}
    
    public func dispatch(_ encoder: MTLRenderCommandEncoder, textureSizeRederence: MTLTexture, primitiveType: MTLPrimitiveType, vertices: [simd_float4]) {
        setVariables(args: &args)
        for (i, key) in args.keys.enumerated() {
            switch args[key] {
            case .bool(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<Bool>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<Bool>.stride, index: i+1)
            case .int(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<Int32>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<Int32>.stride, index: i+1)
            case .int2(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_int2>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_int2>.stride, index: i+1)
            case .int3(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_int3>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_int3>.stride, index: i+1)
            case .int4(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_int4>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_int4>.stride, index: i+1)
            case .float(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<Float>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<Float>.stride, index: i+1)
            case .float2(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_float2>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_float2>.stride, index: i+1)
            case .float3(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_float3>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_float3>.stride, index: i+1)
            case .float4(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_float4>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_float4>.stride, index: i+1)
            case .texture2d(let value, _):
                encoder.setVertexTexture(value, index: i+1)
                encoder.setFragmentTexture(value, index: i+1)
            case .none:
                break
            }
        }
        
        let vertexBuffer = ShaderCore.device.makeBuffer(bytes: vertices, length: MemoryLayout<simd_float4>.stride * vertices.count)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        encoder.setViewport(
            .init(
                originX: 0,
                originY: 0,
                width: Double(textureSizeRederence.width),
                height: Double(textureSizeRederence.height),
                znear: 0.0,
                zfar: 1.0
            )
        )
        
        encoder.setRenderPipelineState(renderPipelineState)
        encoder.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: vertices.count)
    }
}
