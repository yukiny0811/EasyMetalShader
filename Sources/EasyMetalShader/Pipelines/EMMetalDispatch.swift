//
//  EMMetalDispatch.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import MetalKit
import simd

public class EMMetalDispatch {
    
    private let commandBuffer: MTLCommandBuffer
    
    public init() {
        commandBuffer = ShaderCore.commandQueue.makeCommandBuffer()!
    }
    
    public func custom(_ process: @escaping (MTLCommandBuffer) -> ()) {
        process(commandBuffer)
    }
    
    public func compute(_ process: @escaping (MTLComputeCommandEncoder) -> ()) {
        let encoder = commandBuffer.makeComputeCommandEncoder()!
        process(encoder)
        encoder.endEncoding()
    }
    
    public func render(renderTargetTexture: MTLTexture, needsClear: Bool, process: @escaping (MTLRenderCommandEncoder) -> ()) {
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
    }
    
    public func present(drawable: MTLDrawable) {
        commandBuffer.present(drawable)
    }
    
    public func commit() {
        commandBuffer.commit()
        commandBuffer.waitUntilCompleted()
    }
}
