//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import XCTest
@testable import EasyMetalShader

@EMRenderShader
class TestRenderShader {
    
    var p1: Int32 = 0
    var p2: Bool = false
    var p3: Float = 0
    
    var p4: simd_int2 = .zero
    var p5: simd_int3 = .zero
    var p6: simd_int4 = .zero
    
    var p7: simd_float2 = .zero
    var p8: simd_float3 = .zero
    var p9: simd_float4 = .zero
    
    var p10: simd_float2x2 = .init(0)
    var p11: simd_float3x3 = .init(0)
    var p12: simd_float4x4 = .init(0)
    
    var tex1: MTLTexture?
    
    @EMTextureArgument(.read, .type2D)
    var tex2: MTLTexture?
    
    @EMTextureArgument(.read, .type2D)
    var tex3: MTLTexture?
    
    @EMTextureArgument(.sample, .type2D)
    var tex4: MTLTexture?
    
    @EMTextureArgument(.read, .type3D)
    var tex5: MTLTexture?
    
    @EMIgnore
    var tex6: MTLTexture?
    
    @EMTextureArgument(.read)
    var tex7: MTLTexture?
    
    var vertImpl: String {
        "int a = p1;"
        "bool b = p2;"
        "float c = p3;"
        "int2 d = p4;"
        "int3 e = p5;"
        "int4 f = p6;"
        "float2 g = p7;"
        "float3 h = p8;"
        "float4 i = p9;"
        "float2x2 j = p10;"
        "float3x3 k = p11;"
        "float4x4 l = p12;"
        "return rd;"
    }
    
    var fragImpl: String {
        "return float4(0);"
    }
    
    var customMetalCode: String {
        "inline float testFunc(float a) {"
        "return a;"
        "}"
    }
}

class RenderShaderTests: XCTestCase {
    
    func testBuild() throws {
        
        let shader = TestRenderShader(targetPixelFormat: .bgra8Unorm)
        
        shader.tex1 =  EMMetalTexture.create(width: 100, height: 100, pixelFormat: .bgra8Unorm, label: nil)
        shader.tex2 = EMMetalTexture.create(width: 100, height: 100, pixelFormat: .bgra8Unorm, label: nil)
        shader.tex3 = EMMetalTexture.create(width: 100, height: 100, pixelFormat: .bgra8Unorm, label: nil)
    }
}
