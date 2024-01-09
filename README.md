
# EasyMetalShader

Easily create pipelines for Metal Shader.

## Usage

### Create Compute Function

You can easily send any variables to the shader, simply by defining the variables with EMArgument property wrapper.

"gid" is pre-defined for [[thread_position_in_grid]]

```.swift
import EasyMetalShader

class MyCompute: SCMetalComputeFunction {
    
    @EMArgument("tex") var tex: SCMetalTexture = .init(texture: nil, usage: .read_write)
    @EMArgument("col") var col: Float = 0
    
    @ShaderStringBuilder
    override var impl: String {
        "tex.write(float4(col, 0.1, col, 1), gid);"
    }
}
```

### Create Render Function

Same as the compute function, you can send variables to both vertex and fragment shader.

"input" is pre-defined in vertex function as float4, which stands for [[ stage_in ]].

"rd" is pre-defined for both vertex and fragment function, which stands for RasterizerData.

```.metal
//RasterizerData
struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
    
    // use this for defining size of MTLPrimitiveType.point
    // this has no effect when you are using MTLPrimitiveType other than .point
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
    
    // these variables are flat (no interpolation)
    float4 flat1 [[ flat ]];
    float4 flat2 [[ flat ]];
    float4 flat3 [[ flat ]];
    float4 flat4 [[ flat ]];
    float4 flat5 [[ flat ]];
    float4 flat6 [[ flat ]];
    float4 flat7 [[ flat ]];
    float4 flat8 [[ flat ]];
    float4 flat9 [[ flat ]];
};
```

```.swift
import EasyMetalShader

class MyRender: SCMetalRenderFunction {
    
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
```

### Create pipeline and renderer

date and mousePos is defined in ShaderRenderer

```.swift
import EasyMetalShader

class MyRenderer: ShaderRenderer {
    
    var particles: [simd_float4] = {
        var ps: [simd_float4] = []
        for _ in 0...1000{
            ps.append(.init(Float.random(in: -1...1), Float.random(in: -1...1), 0, 1))
        }
        return ps
    }()
    
    let compute = MyCompute()
    let render = MyRender(targetPixelFormat: .bgra8Unorm)
    
    override func draw(view: MTKView, drawable: CAMetalDrawable) {
        let dispatch = SCMetalDispatch()
        dispatch.compute { [self] encoder in
            compute.tex = SCMetalTexture(texture: drawable.texture)
            compute.col = abs(sin(Float(Date().timeIntervalSince(date)))) * 0.9
            compute.dispatch(encoder, textureSizeReference: drawable.texture)
        }
        dispatch.render(renderTargetTexture: drawable.texture, needsClear: false) { [self] encoder in
            render.dispatch(encoder, textureSizeReference: drawable.texture, primitiveType: .point, vertices: particles)
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

### Manual Dispatch

You can manually dispatch compute or render functions outside of MTKView.

```.swift
let tex = SCMetalTexture.create(width: 100, height: 100, pixelFormat: .bgra8Unorm, label: "tex", usage: .read_write)
let dispatch = SCMetalDispatch()
dispatch.compute { encoder in
    compute.tex = SCMetalTexture(texture: tex)
    compute.col = 0.5
    compute.dispatch(encoder, textureSizeReference: tex)
}
dispatch.render(renderTargetTexture: tex, needsClear: false) { encoder in
    render.dispatch(encoder, textureSizeReference: tex, primitiveType: .point, vertices: [simd_float4(0.2, 0.2, 0, 1.0)])
}
dispatch.commit()
```

### Supported Data Types

- Int
- Float
- Bool
- sc_int2 (simd_int2)
- sc_int3 (simd_int3)
- sc_int4 (simd_int4)
- sc_float2 (simd_float2)
- sc_float3 (simd_float3)
- sc_float4 (simd_float4)
- SCMetalTexture (MTLTexture 2D)
