//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import Foundation
import simd

extension MetalPreLibrary {
    static let vertexInput =
"""
struct VertexInput {
    float4 input0 [[ attribute(0) ]];
    float4 input1 [[ attribute(1) ]];
    float4 input2 [[ attribute(2) ]];
    float4 input3 [[ attribute(3) ]];
    float4 input4 [[ attribute(4) ]];
    float4 input5 [[ attribute(5) ]];
    float4 input6 [[ attribute(6) ]];
    float4 input7 [[ attribute(7) ]];
    float4 input8 [[ attribute(8) ]];
    float4 input9 [[ attribute(9) ]];
};
"""
}

public struct VertexInput {
    
    public var input0: simd_float4 = .zero
    public var input1: simd_float4 = .zero
    public var input2: simd_float4 = .zero
    public var input3: simd_float4 = .zero
    public var input4: simd_float4 = .zero
    public var input5: simd_float4 = .zero
    public var input6: simd_float4 = .zero
    public var input7: simd_float4 = .zero
    public var input8: simd_float4 = .zero
    public var input9: simd_float4 = .zero
    
    public init() {}
    
    public init(
        input0: simd_float4,
        input1: simd_float4,
        input2: simd_float4,
        input3: simd_float4,
        input4: simd_float4,
        input5: simd_float4,
        input6: simd_float4,
        input7: simd_float4,
        input8: simd_float4,
        input9: simd_float4
    ) {
        self.input0 = input0
        self.input1 = input1
        self.input2 = input2
        self.input3 = input3
        self.input4 = input4
        self.input5 = input5
        self.input6 = input6
        self.input7 = input7
        self.input8 = input8
        self.input9 = input9
    }
}
