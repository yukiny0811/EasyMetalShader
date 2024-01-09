//
//  Functions.swift
//  ExampleiOS
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import EasyMetalShader

class MyCompute1: SCMetalComputeFunction {
    
    @EMArgument("tex") var tex: SCMetalTexture = .init(texture: nil, usage: .read_write)
    @EMArgument("col") var col: Float = 0
    
    init() {
        super.init(
            functionName: "myCompute1",
            impl: [
                "tex.write(float4(col, 0.1, col, 1), gid);"
            ]
        )
    }
}

class MyRender1: SCMetalRenderFunction {
    
    init() {
        super.init(
            functionName: "myRender1",
            vertImpl: [
                "rd.size = 1;",
                "rd.position = input;",
                "rd.color = float4(1, 0.6, 0.8, 1);",
            ],
            fragImpl: [
                "return rd.color;"
            ],
            targetPixelFormat: .bgra8Unorm
        )
    }
}
