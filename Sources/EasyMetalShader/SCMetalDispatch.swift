//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import MetalKit
import simd

public class SCMetalDispatch {
    
    private let commandBuffer: MTLCommandBuffer
    
    public init() {
        commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
    }
    
    public func compute(_ process: @escaping (MTLComputeCommandEncoder) -> ()) -> Self {
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        process(encoder)
        encoder.endEncoding()
        return self
    }
    
    public func render(renderTargetTexture: MTLTexture, needsClear: Bool, process: @escaping (MTLRenderCommandEncoder) -> ()) -> Self {
        let descriptor = MTLRenderPassDescriptor()
        descriptor.colorAttachments[0].texture = renderTargetTexture
        if needsClear {
            descriptor.colorAttachments[0].loadAction = .clear
        } else {
            descriptor.colorAttachments[0].loadAction = .load
        }
        descriptor.colorAttachments[0].storeAction = .store
        descriptor.colorAttachments[0].clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
        process(encoder)
        encoder.endEncoding()
        return self
    }
    
    public func present(drawable: MTLDrawable) -> Self {
        commandBuffer.present(drawable)
        return self
    }
    
    public func commit() {
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
    }
}
