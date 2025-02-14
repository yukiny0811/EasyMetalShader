
# EasyMetalShader

[![Release](https://img.shields.io/github/v/release/yukiny0811/EasyMetalShader)](https://github.com/yukiny0811/EasyMetalShader/releases/latest)
[![Swift Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2FEasyMetalShader%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/yukiny0811/EasyMetalShader)
[![Platform Compatibility](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fyukiny0811%2FEasyMetalShader%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/yukiny0811/EasyMetalShader)
[![License](https://img.shields.io/github/license/yukiny0811/EasyMetalShader)](https://github.com/yukiny0811/EasyMetalShader/blob/main/LICENSE)

Easily create pipelines for Metal Shader.

## Q&A (AI Documentation)

https://chatgpt.com/g/g-67a4a543c1048191b24ee44bd805f64a-easymetalshader-library-q-a

## Usage

### Create Compute Function

You can easily send any variables to the shader, simply by defining it in your class.

"gid" is pre-defined for [[thread_position_in_grid]]

```.swift
import EasyMetalShader

@EMComputeShader
class MyCompute {
    
    var intensity: Float = 3
    var tex: MTLTexture?
    
    var impl: String {
        "float2 floatGid = float2(gid.x, gid.y);"
        "float2 center = float2(tex.get_width() / 2, tex.get_height() / 2);"
        "float dist = distance(center, floatGid);"
        "float color = intensity / dist;"
        "tex.write(float4(color, color, color, 1), gid);"
    }
    
    var customMetalCode: String {
        ""
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
@EMRenderShader
class MyRender {
    
    var vertImpl: String {
        "rd.size = 10;"
        "rd.position = vertexInput.input0;"
        "rd.color = vertexInput.input1;"
    }
    
    var fragImpl: String {
        "return rd.color + c0;"
    }
    
    var customMetalCode: String {
        ""
    }
}
```

### Create pipeline and renderer

date and mousePos is defined in ShaderRenderer

```.swift
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
let tex = EMMetalTexture.create(width: 100, height: 100, pixelFormat: .bgra8Unorm, label: "tex")
let dispatch = EMMetalDispatch()
dispatch.compute { encoder in
    compute.tex = tex
    compute.intensity = 50
    compute.dispatch(encoder, textureSizeReference: tex)
}
dispatch.render(renderTargetTexture: tex, needsClear: false) { encoder in
    render.dispatch(encoder, textureSizeReference: tex, primitiveType: .point, vertices: [simd_float4(0.2, 0.2, 0, 1.0)])
}
dispatch.commit()
```

### Ignoring variables from being sent to the shader
```.swift
@EMComputeShader
class MyCompute {
    
    @EMIgnore
    var someVariable = 3
}
```

### Custom Constructor

```.swift
@EMComputeShader
class MyCompute {
    
    init(a: Float) {
        setup() // you need this!
    }
}

@EMRenderShader
class MyRender {
    
    init(a: Float) {
        setup(targetPixelFormat: .bgra8unorm) // you need this!
    }
}
```

### Supported Data Types

- Int32
- Float
- Double
- Bool
- simd_int2
- simd_int3
- simd_int4
- simd_float2
- simd_float3
- simd_float4
- simd_float2x2
- simd_float3x3
- simd_float4x4
- simd_double2
- simd_double3
- simd_double4
- simd_double2x2
- simd_double3x3
- simd_double4x4
- MTLTexture (2d)
- MTLTexture (3d)
- IntBuffer (array)
- Int2Buffer (array)
- Int3Buffer (array)
- Int4Buffer (array)
- BoolBuffer (array)
- FloatBuffer (array)
- Float2Buffer (array)
- Float3Buffer (array)
- Float4Buffer (array)

### Supported Platforms
- macOS 11.0~
- iOS 14.0~
- iOS Simulator (render shader only works on physical devices)

### Custom Pipelines

```.swift
let dispatch = EMMetalDispatch()
dispatch.custom { commandBuffer in
    // do something with commandBuffer
}
dispatch.commit()
```

### Custom Metal Functions

implement customMetalCode property to add your original metal codes.

```.swift
var customMetalCode: String {
    "inline float myFunc() {"
    "return 1.0;"
    "}"
}
```

### Compute Shader for 3D Textures

```.swift
@EMComputeShader3D
class MyCompute3D {
    
    @EMTextureArgument(.read, .type3D)
    var tex: MTLTexture?
    
    var impl: String {
        "float4 c = tex.read(gid);"
    }
    
    var customMetalCode: String {
        ""
    }
}
```

## Sample Code


```.swift
// compute shader
@EMComputeShader
class MyCompute {
    
    var intensity: Float = 3
    var tex: MTLTexture?
    
    var impl: String {
        "float2 floatGid = float2(gid.x, gid.y);"
        "float2 center = float2(tex.get_width() / 2, tex.get_height() / 2);"
        "float dist = distance(center, floatGid);"
        "float color = intensity / dist;"
        "tex.write(float4(color, color, color, 1), gid);"
    }
    
    var customMetalCode: String {
        ""
    }
}

// vertex/fragment shader
@EMRenderShader
class MyRender {
    
    var vertImpl: String {
        "rd.size = 10;"
        "rd.position = vertexInput.input0;"
        "rd.color = vertexInput.input1;"
    }
    
    var fragImpl: String {
        "return rd.color + c0;"
    }
    
    var customMetalCode: String {
        ""
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



