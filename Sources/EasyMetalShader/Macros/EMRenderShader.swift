//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import Foundation

@attached(
    extension,
    conformances: EMMetalRenderFunction,
    names: named(renderPipelineState),
    named(args),
    named(init(targetPixelFormat:targetDepthPixelFormat:)),
    named(setup(targetPixelFormat:targetDepthPixelFormat:))
)
@attached(
    member,
    conformances: EMMetalRenderFunction,
    names: named(renderPipelineState),
    named(args),
    named(init(targetPixelFormat:targetDepthPixelFormat:)),
    named(setup(targetPixelFormat:targetDepthPixelFormat:))
)
@attached(memberAttribute)
public macro EMRenderShader() = #externalMacro(module: "EasyMetalShaderMacro", type: "EMRenderShader")
