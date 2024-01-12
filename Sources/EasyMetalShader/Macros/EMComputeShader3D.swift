//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import Foundation

@attached(
    extension,
    conformances: EMMetalComputeFunction,
    names: named(computePipelineState),
    named(args),
    named(init()),
    named(setup())
)
@attached(
    member,
    conformances: EMMetalComputeFunction,
    names: named(computePipelineState),
    named(args),
    named(init()),
    named(setup())
)
@attached(memberAttribute)
public macro EMComputeShader3D() = #externalMacro(module: "EasyMetalShaderMacro", type: "EMComputeShader3D")
