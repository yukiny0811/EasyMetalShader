//
//  Functions.swift
//  ExampleiOS
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import EasyMetalShader

class MyCompute1: EMMetalComputeFunction {
    
    @EMArgument("tex") var tex: EMMetalTexture = .init(texture: nil, usage: .read_write)
    @EMArgument("col") var col: Float = 0
    
    @ShaderStringBuilder
    override var impl: String {
        "tex.write(float4(col, 0.1, col, 1), gid);"
    }
}

class MyRender1: EMMetalRenderFunction {
    
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
