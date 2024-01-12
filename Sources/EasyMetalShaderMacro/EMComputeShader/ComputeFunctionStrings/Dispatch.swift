//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import Foundation

extension ComputeFunctionStrings {
    static let dispatchFunc: String =
"""
public func dispatch(_ encoder: MTLComputeCommandEncoder, textureSizeReference: MTLTexture) {
    for (i, key) in args.keys.enumerated() {
        switch args[key] {
        case .bool(let value):
            encoder.setBytes([value], length: MemoryLayout<Bool>.stride, index: i+1)
        case .int(let value):
            encoder.setBytes([value], length: MemoryLayout<Int32>.stride, index: i+1)
        case .int2(let value):
            encoder.setBytes([value], length: MemoryLayout<simd_int2>.stride, index: i+1)
        case .int3(let value):
            encoder.setBytes([value], length: MemoryLayout<simd_int3>.stride, index: i+1)
        case .int4(let value):
            encoder.setBytes([value], length: MemoryLayout<simd_int4>.stride, index: i+1)
        case .float(let value):
            encoder.setBytes([value], length: MemoryLayout<Float>.stride, index: i+1)
        case .float2(let value):
            encoder.setBytes([value], length: MemoryLayout<simd_float2>.stride, index: i+1)
        case .float3(let value):
            encoder.setBytes([value], length: MemoryLayout<simd_float3>.stride, index: i+1)
        case .float4(let value):
            encoder.setBytes([value], length: MemoryLayout<simd_float4>.stride, index: i+1)
        case .float2x2(let value):
            encoder.setBytes([value], length: MemoryLayout<simd_float2x2>.stride, index: i+1)
        case .float3x3(let value):
            encoder.setBytes([value], length: MemoryLayout<simd_float3x3>.stride, index: i+1)
        case .float4x4(let value):
            encoder.setBytes([value], length: MemoryLayout<simd_float4x4>.stride, index: i+1)
        case .texture2d(let value, _):
            encoder.setTexture(value, index: i+1)
        case .none:
            break
        }
    }
    encoder.setComputePipelineState(computePipelineState)
    let size = Self.createDispatchSize(for: computePipelineState, width: textureSizeReference.width, height: textureSizeReference.height)
    encoder.dispatchThreadgroups(
        size.threadGroupCount,
        threadsPerThreadgroup: size.threadsPerThreadGroup
    )
}
"""
}
