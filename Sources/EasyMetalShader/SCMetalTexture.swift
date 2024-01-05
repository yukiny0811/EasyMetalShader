//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import MetalKit
import simd

public enum SCMetalTexture {
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
        descriptor.resourceOptions = .storageModeManaged
        let texture = ShaderCore.device.makeTexture(descriptor: descriptor)!
        texture.label = label
        return texture
    }
}
