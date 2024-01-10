//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/11.
//

import simd

@objcMembers
public class em_float2x2: NSObject {
    
    public var m00: Float
    public var m01: Float
    
    public var m10: Float
    public var m11: Float
    
    public var simdValue: simd_float2x2 {
        return .init(
            simd_float2(m00, m01),
            simd_float2(m10, m11)
        )
    }
    
    public convenience init(_ value: simd_float2x2) {
        self.init(
            m00: value.columns.0.x,
            m01: value.columns.0.y,
            
            m10: value.columns.1.x,
            m11: value.columns.1.y
        )
    }
    
    public init(
        m00: Float,
        m01: Float,
        m10: Float,
        m11: Float
    ) {
        self.m00 = m00
        self.m01 = m01
        self.m10 = m10
        self.m11 = m11
    }
}
