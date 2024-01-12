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
}
