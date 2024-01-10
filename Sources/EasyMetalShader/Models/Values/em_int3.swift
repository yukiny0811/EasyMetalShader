//
//  em_int3.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import simd

@objcMembers
public class em_int3: NSObject {
    public var x: Int32
    public var y: Int32
    public var z: Int32
    public var simdValue: simd_int3 {
        return .init(x, y, z)
    }
    public convenience init(_ value: simd_int3) {
        self.init(value.x, value.y, value.z)
    }
    public init(_ x: Int32, _ y: Int32, _ z: Int32) {
        self.x = x
        self.y = y
        self.z = z
    }
}
