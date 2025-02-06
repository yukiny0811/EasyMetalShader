//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/11.
//

import XCTest
@testable import EasyMetalShader

class MetalPreLibraryTests: XCTestCase {
    
    func testCompileRand() throws {
        let source = MetalPreLibrary.include + MetalPreLibrary.rand
        try ShaderCore_EasyMetalShaderLib.device.makeLibrary(source: source, options: nil)
    }
    
    func testCompileRasterizerData() throws {
        let source = MetalPreLibrary.include + MetalPreLibrary.rasterizerData
        try ShaderCore_EasyMetalShaderLib.device.makeLibrary(source: source, options: nil)
    }
    
    func testCompileVertexInput() throws {
        let source = MetalPreLibrary.include + MetalPreLibrary.vertexInput
        try ShaderCore_EasyMetalShaderLib.device.makeLibrary(source: source, options: nil)
    }
    
    func testCompileAllCombined() throws {
        let source = MetalPreLibrary.include + MetalPreLibrary.rand + MetalPreLibrary.rasterizerData + MetalPreLibrary.vertexInput
        try ShaderCore_EasyMetalShaderLib.device.makeLibrary(source: source, options: nil)
    }
}
