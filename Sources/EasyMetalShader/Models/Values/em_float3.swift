//
//  em_float3.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import simd

@objcMembers
public class em_float3: NSObject {
    public var x: Float
    public var y: Float
    public var z: Float
    public var simdValue: simd_float3 {
        return .init(x, y, z)
    }
    public convenience init(_ value: simd_float3) {
        self.init(value.x, value.y, value.z)
    }
    public init(_ x: Float, _ y: Float, _ z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}
