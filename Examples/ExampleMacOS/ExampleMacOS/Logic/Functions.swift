//
//  Functions.swift
//  ExampleMacOS
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import EasyMetalShader

class MyCompute1: SCMetalComputeFunction {
    
    @EMArgument("tex") var tex: SCMetalTexture = .init(texture: nil, usage: .read_write)
    @EMArgument("col") var col: Float = 0
    
    @ShaderStringBuilder
    override var impl: String {
        "tex.write(float4(col, 0.1, col, 1), gid);"
    }
}

class MyRender1: SCMetalRenderFunction {
    
    @ShaderStringBuilder
    override var vertImpl: String {
        "rd.size = 1;"
        "rd.position = input;"
        "rd.color = float4(1, 0.6, 0.8, 1);"
    }
    
    @ShaderStringBuilder
    override var fragImpl: String {
        "return rd.color;"
    }
}
