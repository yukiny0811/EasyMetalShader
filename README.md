
# EasyMetalShader

[![Release](https://img.shields.io/github/v/release/yukiny0811/EasyMetalShader)](https://github.com/yukiny0811/EasyMetalShader/releases/latest)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2FEasyMetalShader%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/yukiny0811/EasyMetalShader)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2FEasyMetalShader%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/yukiny0811/EasyMetalShader)
[![License](https://img.shields.io/github/license/yukiny0811/EasyMetalShader)](https://github.com/yukiny0811/EasyMetalShader/blob/main/LICENSE)

Easily create pipelines for Metal Shader.

## Usage

### Create Compute Function

You can easily send any variables to the shader, simply by defining the variables with EMArgument property wrapper.

"gid" is pre-defined for [[thread_position_in_grid]]

```.swift
import EasyMetalShader

class MyCompute: EMMetalComputeFunction {
    
    @EMArgument("tex") var tex: EMMetalTexture = .init(texture: nil, usage: .read_write)
    @EMArgument("col") var col: Float = 0
    
    @ShaderStringBuilder
    override var impl: String {
        "tex.write(float4(col, 0.1, col, 1), gid);"
    }
}
```

### Create Render Function

Same as the compute function, you can send variables to both vertex and fragment shader.

"vertexInput" is pre-defined in vertex function as VertexInput, which stands for [[ stage_in ]].

"c0" is pre-defined in fragment function as float4, which stands for [[ color(0) ]].

"rd" is pre-defined for both vertex and fragment function, which stands for RasterizerData.

```.metal
//VertexInput
struct VertexInput {
    float4 input0 [[ attribute(0) ]]; // this is usually for position
    float4 input1 [[ attribute(1) ]]; // this is usually for color
    float4 input2 [[ attribute(2) ]]; // use other inputs to pass values to vertex shader
    float4 input3 [[ attribute(3) ]];
    float4 input4 [[ attribute(4) ]];
    float4 input5 [[ attribute(5) ]];
    float4 input6 [[ attribute(6) ]];
    float4 input7 [[ attribute(7) ]];
    float4 input8 [[ attribute(8) ]];
    float4 input9 [[ attribute(9) ]];
};

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

class MyRender: EMMetalRenderFunction {
    
    @ShaderStringBuilder
    override var vertImpl: String {
        "rd.size = 1;"
        "rd.position = vertexInput.input0;"
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
let tex = EMMetalTexture.create(width: 100, height: 100, pixelFormat: .bgra8Unorm, label: "tex", usage: .read_write)
let dispatch = EMMetalDispatch()
dispatch.compute { encoder in
    compute.tex = EMMetalTexture(texture: tex)
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
- em_int2 (simd_int2)
- em_int3 (simd_int3)
- em_int4 (simd_int4)
- em_float2 (simd_float2)
- em_float3 (simd_float3)
- em_float4 (simd_float4)
- EMMetalTexture (MTLTexture 2D)

### Custom Pipelines

```.swift
let dispatch = EMMetalDispatch()
dispatch.custom { commandBuffer in
    // do something with commandBuffer
}
dispatch.commit()
```

## Sample Code


```.swift
// compute shader
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

// vertex/fragment shader
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
```

```.swift
// renderer
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
```
```.swift
struct ContentView: View {
    let renderer = MyRenderer()
    var body: some View {
        EasyShaderView(renderer: renderer)
    }
}
```

![outoutout](https://github.com/yukiny0811/EasyMetalShader/assets/28947703/27c53c0b-941a-4e63-8f2d-ca913029ed81)



