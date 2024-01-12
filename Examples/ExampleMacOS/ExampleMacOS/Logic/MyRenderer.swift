//
//  MyRenderer.swift
//  ExampleMacOS
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import EasyMetalShader

class MyRenderer: ShaderRenderer {
    
    var particles: [VertexInput] = {
        var inputs: [VertexInput] = []
        for _ in 0...1000 {
            var input = VertexInput()
            input.input0 = .init(Float.random(in: -1...1), Float.random(in: -1...1), 0, 1)
            input.input1 = .init(Float.random(in: 0.3...1), 0.3, 0.3, 1)
            inputs.append(input)
        }
        return inputs
    }()
    
    let compute = MyCompute()
    let render = MyRender(targetPixelFormat: .bgra8Unorm)
    
    override func draw(view: MTKView, drawable: CAMetalDrawable) {
        let dispatch = EMMetalDispatch()
        dispatch.compute { [self] encoder in
            compute.intensity = abs(sin(Float(Date().timeIntervalSince(date)))) * 100
            compute.tex = drawable.texture
            compute.dispatch(encoder, textureSizeReference: drawable.texture)
        }
        dispatch.render(renderTargetTexture: drawable.texture, needsClear: false) { [self] encoder in
            render.dispatch(encoder, textureSizeReference: drawable.texture, primitiveType: .point, vertices: particles)
        }
        dispatch.present(drawable: drawable)
        dispatch.commit()
    }
}
