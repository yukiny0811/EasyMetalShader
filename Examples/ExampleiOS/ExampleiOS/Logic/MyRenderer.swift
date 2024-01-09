//
//  MyRenderer.swift
//  ExampleiOS
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import EasyMetalShader

class MyRenderer: ShaderRenderer {
    
    var particles: [VertexInput] = {
        var ps: [simd_float4] = []
        for _ in 0...1000 {
            ps.append(.init(Float.random(in: -1...1), Float.random(in: -1...1), 0, 1))
        }
        return ps.map {
            var vertexInput = VertexInput()
            vertexInput.input0 = $0
            return vertexInput
        }
    }()
    
    let compute = MyCompute()
    let render = MyRender(targetPixelFormat: .bgra8Unorm)
    
    override func draw(view: MTKView, drawable: CAMetalDrawable) {
        let dispatch = EMMetalDispatch()
        dispatch.compute { [self] encoder in
            compute.tex = EMMetalTexture(texture: drawable.texture)
            compute.intensity = abs(sin(Float(Date().timeIntervalSince(date)))) * 100
            compute.dispatch(encoder, textureSizeReference: drawable.texture)
        }
        dispatch.render(renderTargetTexture: drawable.texture, needsClear: false) { [self] encoder in
            render.dispatch(encoder, textureSizeReference: drawable.texture, primitiveType: .point, vertices: particles)
        }
        dispatch.present(drawable: drawable)
        dispatch.commit()
    }
}

