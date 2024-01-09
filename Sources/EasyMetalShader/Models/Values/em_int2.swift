//
//  em_int2.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import simd

@objcMembers
public class em_int2: NSObject {
    public var x: Int32
    public var y: Int32
    public var simdValue: simd_int2 {
        return .init(x, y)
    }
    public init(_ x: Int32, _ y: Int32) {
        self.x = x
        self.y = y
    }
}
