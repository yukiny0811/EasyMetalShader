//
//  EMMetalTexture.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import MetalKit
import simd

@objcMembers
public class EMMetalTexture: NSObject {
    
    public var texture: MTLTexture?
    public var usage: EMMetalTextureUsage
    
    public init(texture: MTLTexture?, usage: EMMetalTextureUsage) {
        self.texture = texture
        self.usage = usage
    }
    
    public static func create(width: Int, height: Int, pixelFormat: MTLPixelFormat, label: String?) -> MTLTexture {
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = pixelFormat
        descriptor.textureType = .type2D
        descriptor.width = width
        descriptor.height = height
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        descriptor.resourceOptions = .storageModePrivate
        let texture = ShaderCore.device.makeTexture(descriptor: descriptor)!
        texture.label = label
        return texture
    }
    
    public static func createManaged(width: Int, height: Int, pixelFormat: MTLPixelFormat, label: String?) -> MTLTexture {
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = pixelFormat
        descriptor.textureType = .type2D
        descriptor.width = width
        descriptor.height = height
        descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        #if os(macOS)
        descriptor.resourceOptions = .storageModeManaged
        #elseif os(iOS)
        descriptor.resourceOptions = .storageModeShared
        #endif
        let texture = ShaderCore.device.makeTexture(descriptor: descriptor)!
        texture.label = label
        return texture
    }
}

public extension MTLTexture {
    
    // dont use this before shader compilation!
    var emTexture: EMMetalTexture {
        .init(texture: self, usage: .read)
    }
}
