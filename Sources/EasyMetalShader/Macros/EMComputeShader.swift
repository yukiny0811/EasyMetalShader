//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import Foundation
import EasyMetalShaderMacro

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
public macro EMComputeShader() = #externalMacro(module: "EasyMetalShaderMacro", type: "EMComputeShader")
