//
//  EMMetalComputeFunction.swift
//
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import MetalKit
import simd

@objcMembers
open class EMMetalComputeFunction: NSObject, EMMetalFunction {
    
    private static let initialMetalHeader = MetalPreLibrary.include + MetalPreLibrary.rand
    
    var computePipelineState: MTLComputePipelineState!
    
    public var args: [String: EMMetalArgument] = [:]
    
    @ShaderStringBuilder 
    open var impl: String {
        ""
    }
    
    @ShaderStringBuilder
    open var customMetalCode: String {
        ""
    }
    
    public override init() {
        super.init()
        
        MirrorUtil.setInitialValue(for: self)
        
        let tempFunctionName = "f" + UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "")
        
        var functionImpl = ""
        functionImpl += Self.initialMetalHeader
        functionImpl += customMetalCode
        functionImpl += "kernel void \(tempFunctionName)("
        
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
            case .float4x4(_):
                functionImpl += "device const float4x4* \(key)_buf [[buffer(\(i+1))]]"
            case .texture2d(_, let usage):
                switch usage {
                case .read:
                    functionImpl += "texture2d<float, access::read> \(key) [[texture(\(i+1))]]"
                case .write:
                    functionImpl += "texture2d<float, access::write> \(key) [[texture(\(i+1))]]"
                case .read_write:
                    functionImpl += "texture2d<float, access::read_write> \(key) [[texture(\(i+1))]]"
                case .sample:
                    functionImpl += "texture2d<float, access::sample> \(key) [[texture(\(i+1))]]"
                }
            case .none:
                break
            }
            functionImpl += ","
        }
        functionImpl += "ushort2 gid [[thread_position_in_grid]]"
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
            case .float4x4(_):
                functionImpl += "float4x4 \(key) = \(key)_buf[0];"
            case .texture2d(_, _):
                break
            case .none:
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
    
    private func createDispatchSize(
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
            case .float4x4(let value):
                encoder.setBytes([value], length: MemoryLayout<simd_float4x4>.stride, index: i+1)
            case .texture2d(let value, _):
                encoder.setTexture(value, index: i+1)
            case .none:
                break
            }
        }
        encoder.setComputePipelineState(computePipelineState)
        let size = createDispatchSize(for: computePipelineState, width: textureSizeReference.width, height: textureSizeReference.height)
        encoder.dispatchThreadgroups(
            size.threadGroupCount,
            threadsPerThreadgroup: size.threadsPerThreadGroup
        )
    }
}
