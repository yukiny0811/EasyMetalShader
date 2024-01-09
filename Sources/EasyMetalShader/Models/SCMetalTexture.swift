//
//  SCMetalTexture.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import MetalKit
import simd

@objcMembers
public class SCMetalTexture: NSObject {
    
    public var texture: MTLTexture?
    public var usage: SCMetalTextureUsage
    
    public init(texture: MTLTexture?, usage: SCMetalTextureUsage = .read_write) {
        self.texture = texture
        self.usage = usage
    }
    
    public static func create(width: Int, height: Int, pixelFormat: MTLPixelFormat, label: String?, usage: SCMetalTextureUsage) -> SCMetalTexture {
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = pixelFormat
        descriptor.textureType = .type2D
        descriptor.width = width
        descriptor.height = height
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        descriptor.resourceOptions = .storageModePrivate
        let texture = ShaderCore.device.makeTexture(descriptor: descriptor)!
        texture.label = label
        return SCMetalTexture(texture: texture, usage: usage)
    }
    
    public static func createManaged(width: Int, height: Int, pixelFormat: MTLPixelFormat, label: String?, usage: SCMetalTextureUsage) -> SCMetalTexture {
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = pixelFormat
        descriptor.textureType = .type2D
        descriptor.width = width
        descriptor.height = height
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        descriptor.resourceOptions = .storageModeManaged
        let texture = ShaderCore.device.makeTexture(descriptor: descriptor)!
        texture.label = label
        return SCMetalTexture(texture: texture, usage: usage)
    }
}
