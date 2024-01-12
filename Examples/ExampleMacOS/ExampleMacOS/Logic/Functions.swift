//
//  Functions.swift
//  ExampleMacOS
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import EasyMetalShader

@EMComputeShader
class MyCompute {
    
    var intensity: Float = 3
    
    @EMTextureArgument(.write)
    var tex: MTLTexture? = nil
    
    @ShaderStringBuilder
    var impl: String {
        "float2 floatGid = float2(gid.x, gid.y);"
        "float2 center = float2(tex.get_width() / 2, tex.get_height() / 2);"
        "float dist = distance(center, floatGid);"
        "float color = intensity / dist;"
        "tex.write(float4(color, color, color, 1), gid);"
    }
    
    @ShaderStringBuilder
    var customMetalCode: String {
        ""
    }
}

class MyRender: EMMetalRenderFunction {
    
    @ShaderStringBuilder
    override var vertImpl: String {
        "rd.size = 10;"
        "rd.position = vertexInput.input0;"
        "rd.color = vertexInput.input1;"
    }
    
    @ShaderStringBuilder
    override var fragImpl: String {
        "return rd.color + c0;"
    }
}
