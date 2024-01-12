//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import MetalKit

@attached(accessor, names: named(didSet))
public macro EMTextureArgument(_ usage: EMMetalTextureUsage, _ type: MTLTextureType) = #externalMacro(module: "EasyMetalShaderMacro", type: "EMTextureArgument")
