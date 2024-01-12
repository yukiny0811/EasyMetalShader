//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

@attached(accessor, names: named(didSet))
public macro EMTextureArgument(_ usage: EMMetalTextureUsage) = #externalMacro(module: "EasyMetalShaderMacro", type: "EMTextureArgument")
