//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import Foundation
import simd
import MetalKit

public protocol EMMetalComputeFunction: AnyObject {
    
    var computePipelineState: MTLComputePipelineState! { get }
    
    var args: [String: EMMetalArgument] { get set }
    
    @ShaderStringBuilder
    var impl: String { get }
    
    @ShaderStringBuilder
    var customMetalCode: String { get }
}

extension EMMetalComputeFunction {
    public static var initialMetalHeader: String {
        MetalPreLibrary.include + MetalPreLibrary.rand
    }
    public static func createDispatchSize(
        for pipe: MTLComputePipelineState,
        width: Int,
        height: Int
    ) -> (threadGroupCount: MTLSize, threadsPerThreadGroup: MTLSize) {
        let maxTotalThreadsPerThreadgroup = pipe.maxTotalThreadsPerThreadgroup
        let threadExecutionWidth = pipe.threadExecutionWidth
        let threadsPerThreadgroup = MTLSize(
            width: threadExecutionWidth,
            height: maxTotalThreadsPerThreadgroup / threadExecutionWidth,
            depth: 1
        )
        let threadGroupCount = MTLSize(
            width: width / threadsPerThreadgroup.width+1,
            height: height / threadsPerThreadgroup.height+1,
            depth: 1
        )
        return (threadGroupCount, threadsPerThreadgroup)
    }
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
}
