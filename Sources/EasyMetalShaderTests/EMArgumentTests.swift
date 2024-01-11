//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/11.
//

import XCTest
@testable import EasyMetalShader

class EMArgumentTests: XCTestCase {
    
    func testBool() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: Bool = true
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: Bool = true
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .bool(true) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .bool(true) = render.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        compute.p = false
        render.p = false
        guard case .bool(false) = compute.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        guard case .bool(false) = render.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
    }
    
    func testInt() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: Int32 = 1
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: Int32 = 1
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .int(1) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .int(1) = render.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        compute.p = 2
        render.p = 2
        guard case .int(2) = compute.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        guard case .int(2) = render.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
    }
    
    func testFloat() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: Float = 1
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: Float = 1
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .float(1) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .float(1) = render.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        compute.p = 2
        render.p = 2
        guard case .float(2) = compute.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        guard case .float(2) = render.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
    }
    
    func testInt2() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_int2 = .init(.one)
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_int2 = .init(.one)
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .int2(.one) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .int2(.one) = render.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        compute.p = .init(2, 2)
        render.p = .init(2, 2)
        guard case .int2(.init(2, 2)) = compute.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        guard case .int2(.init(2, 2)) = render.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
    }
    
    func testInt3() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_int3 = .init(.one)
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_int3 = .init(.one)
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .int3(.one) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .int3(.one) = render.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        compute.p = .init(2, 2, 2)
        render.p = .init(2, 2, 2)
        guard case .int3(.init(2, 2, 2)) = compute.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        guard case .int3(.init(2, 2, 2)) = render.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
    }
    
    func testInt4() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_int4 = .init(.one)
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_int4 = .init(.one)
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .int4(.one) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .int4(.one) = render.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        compute.p = .init(2, 2, 2, 2)
        render.p = .init(2, 2, 2, 2)
        guard case .int4(.init(2, 2, 2, 2)) = compute.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        guard case .int4(.init(2, 2, 2, 2)) = render.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
    }
    
    func testFloat2() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_float2 = .init(.one)
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_float2 = .init(.one)
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .float2(.one) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .float2(.one) = render.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        compute.p = .init(.one * 2)
        render.p = .init(.one * 2)
        guard case .float2(.init(.one * 2)) = compute.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        guard case .float2(.init(.one * 2)) = render.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
    }
    
    func testFloat3() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_float3 = .init(.one)
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_float3 = .init(.one)
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .float3(.one) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .float3(.one) = render.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        compute.p = .init(.one * 2)
        render.p = .init(.one * 2)
        guard case .float3(.init(.one * 2)) = compute.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        guard case .float3(.init(.one * 2)) = render.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
    }
    
    func testFloat4() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_float4 = .init(.one)
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_float4 = .init(.one)
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .float4(.one) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .float4(.one) = render.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        compute.p = .init(.one * 2)
        render.p = .init(.one * 2)
        guard case .float4(.init(.one * 2)) = compute.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        guard case .float4(.init(.one * 2)) = render.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
    }
    
    func testFloat2x2() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_float2x2 = .init(.init(1))
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_float2x2 = .init(.init(1))
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .float2x2(.init(1)) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .float2x2(.init(1)) = render.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        compute.p = .init(.init(2))
        render.p = .init(.init(2))
        guard case .float2x2(.init(.init(2))) = compute.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        guard case .float2x2(.init(.init(2))) = render.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
    }
    
    func testFloat3x3() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_float3x3 = .init(.init(1))
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_float3x3 = .init(.init(1))
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .float3x3(.init(1)) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .float3x3(.init(1)) = render.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        compute.p = .init(.init(2))
        render.p = .init(.init(2))
        guard case .float3x3(.init(.init(2))) = compute.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        guard case .float3x3(.init(.init(2))) = render.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
    }
    
    func testFloat4x4() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_float4x4 = .init(.init(1))
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: em_float4x4 = .init(.init(1))
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .float4x4(.init(1)) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .float4x4(.init(1)) = render.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        compute.p = .init(.init(2))
        render.p = .init(.init(2))
        guard case .float4x4(.init(.init(2))) = compute.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        guard case .float4x4(.init(.init(2))) = render.args["p"]! else {
            XCTFail("emargument update failure")
            throw NSError()
        }
    }
    
    func testMTLTexture() throws {
        class TestComputeFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: EMMetalTexture = .init(texture: nil, usage: .read)
        }
        class TestRenderFunction: EMMetalComputeFunction {
            @EMArgument("p") var p: EMMetalTexture = .init(texture: nil, usage: .read)
        }
        let compute = TestComputeFunction()
        let render = TestRenderFunction()
        XCTAssertNotNil(compute.args["p"])
        XCTAssertNotNil(render.args["p"])
        guard case .texture2d(nil, .read) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        guard case .texture2d(nil, .read) = compute.args["p"]! else {
            XCTFail("emargument initialization failure")
            throw NSError()
        }
        let testTexture = EMMetalTexture.create(width: 3, height: 3, pixelFormat: .bgra8Unorm, label: nil)
        compute.p = testTexture.emTexture
        render.p = testTexture.emTexture
        if case .texture2d(let tex, .read) = compute.args["p"]! {
            let t = try XCTUnwrap(tex)
            XCTAssertEqual(testTexture.width, t.width)
            XCTAssertEqual(testTexture.height, t.height)
            XCTAssertEqual(testTexture.usage, t.usage)
            XCTAssertEqual(testTexture.pixelFormat, t.pixelFormat)
        } else {
            XCTFail("emargument update failure")
            throw NSError()
        }
        if case .texture2d(let tex, .read) = render.args["p"]! {
            let t = try XCTUnwrap(tex)
            XCTAssertEqual(testTexture.width, t.width)
            XCTAssertEqual(testTexture.height, t.height)
            XCTAssertEqual(testTexture.usage, t.usage)
            XCTAssertEqual(testTexture.pixelFormat, t.pixelFormat)
        } else {
           XCTFail("emargument update failure")
           throw NSError()
       }
    }
}
