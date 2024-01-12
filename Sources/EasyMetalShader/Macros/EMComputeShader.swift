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
    named(dispatch(_:textureSizeReference:))
)
@attached(
    member,
    conformances: EMMetalComputeFunction,
    names: named(computePipelineState),
    named(args),
    named(init()),
    named(dispatch(_:textureSizeReference:))
)
@attached(memberAttribute)
public macro EMComputeShader() = #externalMacro(module: "EasyMetalShaderMacro", type: "EMComputeShader")
