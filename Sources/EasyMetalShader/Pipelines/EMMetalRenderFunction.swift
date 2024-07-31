//
//  EMMetalRenderFunction.swift
//
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import Foundation
import simd
import MetalKit

public protocol EMMetalRenderFunction: AnyObject {
    
    var renderPipelineState: MTLRenderPipelineState! { get }
    
    var args: [String: EMMetalArgument] { get set }
    
    @ShaderStringBuilder var vertImpl: String {
        get
    }
    
    @ShaderStringBuilder var fragImpl: String {
        get
    }
    
    @ShaderStringBuilder
    var customMetalCode: String {
        get
    }
}

extension EMMetalRenderFunction {
    public static var initialMetalHeader: String {
        MetalPreLibrary.include + MetalPreLibrary.rand + MetalPreLibrary.rasterizerData + MetalPreLibrary.vertexInput
    }
    public func dispatch(_ encoder: MTLRenderCommandEncoder, textureSizeReference: MTLTexture, primitiveType: MTLPrimitiveType, vertices: [VertexInput]) {
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
            case .float2x2(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_float2x2>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_float2x2>.stride, index: i+1)
            case .float3x3(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_float3x3>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_float3x3>.stride, index: i+1)
            case .float4x4(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_float4x4>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_float4x4>.stride, index: i+1)
            case .double(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<Double>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<Double>.stride, index: i+1)
            case .double2(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_double2>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_double2>.stride, index: i+1)
            case .double3(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_double3>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_double3>.stride, index: i+1)
            case .double4(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_double4>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_double4>.stride, index: i+1)
            case .double2x2(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_double2x2>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_double2x2>.stride, index: i+1)
            case .double3x3(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_double3x3>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_double3x3>.stride, index: i+1)
            case .double4x4(let value):
                encoder.setVertexBytes([value], length: MemoryLayout<simd_double4x4>.stride, index: i+1)
                encoder.setFragmentBytes([value], length: MemoryLayout<simd_double4x4>.stride, index: i+1)
            case .texture2d(let value, _):
                encoder.setVertexTexture(value, index: i+1)
                encoder.setFragmentTexture(value, index: i+1)
            case .texture3d(let value, _):
                encoder.setVertexTexture(value, index: i+1)
                encoder.setFragmentTexture(value, index: i+1)
            case .boolBuffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .intBuffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .int2Buffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .int3Buffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .int4Buffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .floatBuffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .float2Buffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .float3Buffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .float4Buffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .doubleBuffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .double2Buffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .double3Buffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .double4Buffer(let value):
                encoder.setVertexBuffer(value.buffer, offset: 0, index: i+1)
                encoder.setFragmentBuffer(value.buffer, offset: 0, index: i+1)
            case .none:
                break
            }
        }
        
        let vertexBuffer = ShaderCore.device.makeBuffer(bytes: vertices, length: MemoryLayout<VertexInput>.stride * vertices.count)
        encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        encoder.setViewport(
            .init(
                originX: 0,
                originY: 0,
                width: Double(textureSizeReference.width),
                height: Double(textureSizeReference.height),
                znear: 0.0,
                zfar: 1.0
            )
        )
        
        encoder.setRenderPipelineState(renderPipelineState)
        encoder.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: vertices.count)
    }
}
