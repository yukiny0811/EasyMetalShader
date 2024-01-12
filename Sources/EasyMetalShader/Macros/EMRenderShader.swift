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
    conformances: EMMetalRenderFunction,
    names: named(renderPipelineState),
    named(args),
    named(init(targetPixelFormat:)),
    named(setup(targetPixelFormat:))
)
@attached(
    member,
    conformances: EMMetalRenderFunction,
    names: named(renderPipelineState),
    named(args),
    named(init(targetPixelFormat:)),
    named(setup(targetPixelFormat:))
)
@attached(memberAttribute)
public macro EMRenderShader() = #externalMacro(module: "EasyMetalShaderMacro", type: "EMRenderShader")
