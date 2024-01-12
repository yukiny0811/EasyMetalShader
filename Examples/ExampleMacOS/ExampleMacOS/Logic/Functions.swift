//
//  Functions.swift
//  ExampleMacOS
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import EasyMetalShader
import simd

@EMComputeShader
class MyCompute {
    
//    var intensity: Float = 3
//    var aaa: Bool = false
//    var bbb: Int32 = 1
//    
//    var ccc: simd_int2 = .one
//    var ccc2: simd_int3 = .one
//    var ccc3: simd_int4 = .one
//    
//    var p1: SIMD2<Int32> = .one
//    var p2: SIMD3<Int32> = .one
//    var p3: SIMD4<Int32> = .one
//    
//    var p4: simd_float2 = .one
//    var p5: simd_float3 = .one
//    var p6: simd_float4 = .one
//    
//    var p7: SIMD2<Float> = .one
//    var p8: SIMD3<Float> = .one
//    var p9: SIMD4<Float> = .one
//    
//    var k1: simd_float2x2 = .init(1)
//    var k2: simd_float3x3 = .init(1)
//    var k3: simd_float4x4 = .init(1)
//    
//    var tex: MTLTexture?
//    
//    @EMIgnore
//    var a: Bool
//    
//    init(a: Bool) {
//        self.a = a
//        setup()
//    }
    
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
