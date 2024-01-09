//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import simd

@objcMembers
public class sc_int4: NSObject {
    public var x: Int32
    public var y: Int32
    public var z: Int32
    public var w: Int32
    public var simdValue: simd_int4 {
        return .init(x, y, z, w)
    }
    public init(_ x: Int32, _ y: Int32, _ z: Int32, _ w: Int32) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
}
