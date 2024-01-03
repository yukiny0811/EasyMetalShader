//
//  Functions.swift
//  ExampleMacOS
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import EasyMetalShader

class MyCompute1: SCMetalComputeFunction {
    
    var tex: MTLTexture?
    var col: Float = 0
    
    init() {
        super.init(
            functionName: "myCompute1",
            args: [
                "tex": .texture2d(tex, .read_write),
                "col": .float(col)
            ],
            impl: [
                "tex.write(float4(col, 0.1, col, 1), gid);"
            ]
        )
    }
    
    override func setVariables(args: inout [String : SCMetalArgument]) {
        args["tex"] = .texture2d(tex, .read_write)
        args["col"] = .float(col)
    }
}

class MyRender1: SCMetalRenderFunction {
    
    init() {
        super.init(
            functionName: "myRender1",
            args: [:],
            vertImpl: [
                "rd.size = 1;",
                "rd.position = input;",
                "rd.color = float4(1, 0.6, 0.8, 1);",
            ],
            fragImpl: [
                "return rd.color;"
            ],
            targetPixelFormat: .rgba8Unorm
        )
    }
}
