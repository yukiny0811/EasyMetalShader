//
//  Functions.swift
//  ExampleMacOS
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import EasyMetalShader

class MyCompute: EMMetalComputeFunction {
    
    @EMArgument("tex") var tex: EMMetalTexture = .init(texture: nil, usage: .read_write)
    @EMArgument("intensity") var intensity: Float = 0
    
    @ShaderStringBuilder
    override var impl: String {
        "float2 floatGid = float2(gid.x, gid.y);"
        "float2 center = float2(tex.get_width() / 2, tex.get_height() / 2);"
        "float dist = distance(center, floatGid);"
        "float color = intensity / dist;"
        "tex.write(float4(color, color, color, 1), gid);"
    }
}

class MyRender: EMMetalRenderFunction {
    
    @ShaderStringBuilder
    override var vertImpl: String {
        "rd.size = 10;"
        "rd.position = vertexInput.input0;"
        "rd.color = float4(1, 0.6, 0.8, 1);"
    }
    
    @ShaderStringBuilder
    override var fragImpl: String {
        "return rd.color + c0;"
    }
}
