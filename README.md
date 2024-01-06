
# EasyMetalShader

Easily create pipelines for Metal Shader.

## Usage

### Create Compute Function

You can use any variables, simply by the name defined in args.

"gid" is also defined for [[thread_position_in_grid]]

```.swift
import EasyMetalShader

class MyCompute: SCMetalComputeFunction {
    
    var tex: MTLTexture?
    var col: Float = 0
    
    init() {
        super.init(
            functionName: "myCompute",
            args: [
                "tex": .texture2d(tex, .read_write),
                "col": .float(col)
            ],
            impl: [
                "tex.write(float4(col, col, col, 1), gid);"
            ]
        )
    }
    
    override func setVariables(args: inout [String : SCMetalArgument]) {
        args["tex"] = .texture2d(tex, .read_write)
        args["col"] = .float(col)
    }
}
```

### Create Render Function

Same as compute function, you can use any variables in both vertex and fragment shader, simply by the name defined in args.

"input" is defined for vertex function as float4, which is for [[stage_in]].

"rd" is also defined for both vertex and fragment function as RasterizerData.

```.metal
//RasterizerData
struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
    float size [[ point_size ]];

    // use this for passing some variables from vertex shader to fragment shader
    float4 temp1;
    float4 temp2;
    float4 temp3;
    float4 temp4;
    float4 temp5;
    float4 temp6;
    float4 temp7;
    float4 temp8;
    float4 temp9;
};
```

```.swift
import EasyMetalShader

class MyRender: SCMetalRenderFunction {
    
    init() {
        super.init(
            functionName: "myRender",
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
```

### Create pipeline and renderer

date and mousePos is defined in ShaderRenderer

```.swift
import EasyMetalShader

class MyRenderer: ShaderRenderer {
    
    var particles: [simd_float4] = {
        var ps: [simd_float4] = []
        for _ in 0...1000 {
            ps.append(.init(Float.random(in: -1...1), Float.random(in: -1...1), 0, 1))
        }
        return ps
    }()
    
    let compute = MyCompute()
    let render = MyRender()
    
    override func draw(view: MTKView, drawable: CAMetalDrawable) {
        
        let dispatch = SCMetalDispatch()
        dispatch.compute { [self] encoder in
            compute.tex = drawable.texture
            compute.col = abs(sin(Float(Date().timeIntervalSince(date)))) * 0.9
            compute.dispatch(encoder, textureSizeReference: drawable.texture)
        }
        dispatch.render(renderTargetTexture: drawable.texture, needsClear: false) { [self] encoder in
            render.dispatch(encoder, textureSizeRederence: drawable.texture, primitiveType: .point, vertices: particles)
        }
        dispatch.present(drawable: drawable)
        dispatch.commit()
    }
}
```

### Show in SwiftUI View

```.swift
import SwiftUI
import EasyMetalShader

struct ContentView: View {
    let renderer = MyRenderer()
    var body: some View {
        EasyShaderView(renderer: renderer)
    }
}
```

## Notes

You can manually dispatch compute or render functions outside of MTKView.

```.swift
let tex = SCMetalTexture.create(width: 100, height: 100, pixelFormat: .rgba8unorm, label: "tex")
let dispatch = SCMetalDispatch()
dispatch.compute { encoder in
    compute.tex = tex
    compute.col = 0.5
    compute.dispatch(encoder, textureSizeReference: tex)
}
dispatch.render(renderTargetTexture: tex, needsClear: false) { encoder in
    render.dispatch(encoder, textureSizeRederence: tex, primitiveType: .point, vertices: [simd_float4(0.2, 0.2, 0, 1.0)])
}
dispatch.commit()
```


