//
//  em_float2.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import simd

@objcMembers
public class em_float2: NSObject {
    public var x: Float
    public var y: Float
    public var simdValue: simd_float2 {
        return .init(x, y)
    }
    public convenience init(_ value: simd_float2) {
        self.init(value.x, value.y)
    }
    public init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
}
