//
//  MyRenderer.swift
//  ExampleiOS
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import EasyMetalShader

class MyRenderer: ShaderRenderer {
    
    var particles: [simd_float4] = {
        var ps: [simd_float4] = []
        for _ in 0...100000 {
            ps.append(.init(Float.random(in: -1...1), Float.random(in: -1...1), 0, 1))
        }
        return ps
    }()
    
    let compute1 = MyCompute1()
    let render1 = MyRender1()
    
    override func draw(view: MTKView, drawable: CAMetalDrawable) {
        let dispatch = SCMetalDispatch()
        dispatch.compute { [self] encoder in
            compute1.tex = SCMetalTexture(texture: drawable.texture)
            compute1.col = abs(sin(Float(Date().timeIntervalSince(date)))) * 0.9
            compute1.dispatch(encoder, textureSizeReference: drawable.texture)
        }
        dispatch.render(renderTargetTexture: drawable.texture, needsClear: false) { [self] encoder in
            render1.dispatch(encoder, textureSizeReference: drawable.texture, primitiveType: .point, vertices: particles)
        }
        dispatch.present(drawable: drawable)
        dispatch.commit()
    }
}

