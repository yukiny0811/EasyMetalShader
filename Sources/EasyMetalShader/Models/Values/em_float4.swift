//
//  em_float4.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import simd

@objcMembers
public class em_float4: NSObject {
    public var x: Float
    public var y: Float
    public var z: Float
    public var w: Float
    public var simdValue: simd_float4 {
        return .init(x, y, z, w)
    }
    public convenience init(_ value: simd_float4) {
        self.init(value.x, value.y, value.z, value.w)
    }
    public init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
}
