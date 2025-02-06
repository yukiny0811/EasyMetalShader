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
    
    public static func create(width: Int, height: Int, pixelFormat: MTLPixelFormat, label: String?, isRenderTarget: Bool = true) -> MTLTexture {
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = pixelFormat
        descriptor.textureType = .type2D
        descriptor.width = width
        descriptor.height = height
        if isRenderTarget {
            descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        } else {
            descriptor.usage = [.shaderRead, .shaderWrite]
        }
        descriptor.resourceOptions = .storageModePrivate
        let texture = ShaderCore_EasyMetalShaderLib.device.makeTexture(descriptor: descriptor)!
        texture.label = label
        return texture
    }
    
    public static func createManaged(width: Int, height: Int, pixelFormat: MTLPixelFormat, label: String?, isRenderTarget: Bool = true) -> MTLTexture {
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = pixelFormat
        descriptor.textureType = .type2D
        descriptor.width = width
        descriptor.height = height
        if isRenderTarget {
            descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        } else {
            descriptor.usage = [.shaderRead, .shaderWrite]
        }
        #if os(macOS)
        descriptor.resourceOptions = .storageModeManaged
        #elseif os(iOS)
        descriptor.resourceOptions = .storageModeShared
        #endif
        let texture = ShaderCore_EasyMetalShaderLib.device.makeTexture(descriptor: descriptor)!
        texture.label = label
        return texture
    }
    
    public static func create3d(width: Int, height: Int, depth: Int, pixelFormat: MTLPixelFormat, label: String?, isRenderTarget: Bool = true) -> MTLTexture {
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = pixelFormat
        descriptor.textureType = .type3D
        descriptor.width = width
        descriptor.height = height
        descriptor.depth = depth
        if isRenderTarget {
            descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        } else {
            descriptor.usage = [.shaderRead, .shaderWrite]
        }
        descriptor.resourceOptions = .storageModePrivate
        let texture = ShaderCore_EasyMetalShaderLib.device.makeTexture(descriptor: descriptor)!
        texture.label = label
        return texture
    }
    
    public static func createManaged3d(width: Int, height: Int, depth: Int, pixelFormat: MTLPixelFormat, label: String?, isRenderTarget: Bool = true) -> MTLTexture {
        let descriptor = MTLTextureDescriptor()
        descriptor.pixelFormat = pixelFormat
        descriptor.textureType = .type3D
        descriptor.width = width
        descriptor.height = height
        descriptor.depth = depth
        if isRenderTarget {
            descriptor.usage = [.shaderRead, .shaderWrite, .renderTarget]
        } else {
            descriptor.usage = [.shaderRead, .shaderWrite]
        }
        #if os(macOS)
        descriptor.resourceOptions = .storageModeManaged
        #elseif os(iOS)
        descriptor.resourceOptions = .storageModeShared
        #endif
        let texture = ShaderCore_EasyMetalShaderLib.device.makeTexture(descriptor: descriptor)!
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
