//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/11.
//

import simd

@objcMembers
public class em_float3x3: NSObject {
    
    public var m00: Float
    public var m01: Float
    public var m02: Float
    
    public var m10: Float
    public var m11: Float
    public var m12: Float
    
    public var m20: Float
    public var m21: Float
    public var m22: Float
    
    public var simdValue: simd_float3x3 {
        return .init(
            simd_float3(m00, m01, m02),
            simd_float3(m10, m11, m12),
            simd_float3(m20, m21, m22)
        )
    }
    
    public convenience init(_ value: simd_float3x3) {
        self.init(
            m00: value.columns.0.x,
            m01: value.columns.0.y,
            m02: value.columns.0.z,
            
            m10: value.columns.1.x,
            m11: value.columns.1.y,
            m12: value.columns.1.z,
            
            m20: value.columns.2.x,
            m21: value.columns.2.y,
            m22: value.columns.2.z
        )
    }
    
    public init(
        m00: Float,
        m01: Float,
        m02: Float,
        m10: Float,
        m11: Float,
        m12: Float,
        m20: Float,
        m21: Float,
        m22: Float
    ) {
        self.m00 = m00
        self.m01 = m01
        self.m02 = m02
        self.m10 = m10
        self.m11 = m11
        self.m12 = m12
        self.m20 = m20
        self.m21 = m21
        self.m22 = m22
    }
}
