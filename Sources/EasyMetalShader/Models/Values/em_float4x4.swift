//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/10.
//

import simd

@objcMembers
public class em_float4x4: NSObject {
    
    public var m00: Float
    public var m01: Float
    public var m02: Float
    public var m03: Float
    
    public var m10: Float
    public var m11: Float
    public var m12: Float
    public var m13: Float
    
    public var m20: Float
    public var m21: Float
    public var m22: Float
    public var m23: Float
    
    public var m30: Float
    public var m31: Float
    public var m32: Float
    public var m33: Float
    
    public var simdValue: simd_float4x4 {
        return .init(
            simd_float4(m00, m01, m02, m03),
            simd_float4(m10, m11, m12, m13),
            simd_float4(m20, m21, m22, m23),
            simd_float4(m30, m31, m32, m33)
        )
    }
    
    public convenience init(_ value: simd_float4x4) {
        self.init(
            m00: value.columns.0.x,
            m01: value.columns.0.y,
            m02: value.columns.0.z,
            m03: value.columns.0.w,
            
            m10: value.columns.1.x,
            m11: value.columns.1.y,
            m12: value.columns.1.z,
            m13: value.columns.1.w,
            
            m20: value.columns.2.x,
            m21: value.columns.2.y,
            m22: value.columns.2.z,
            m23: value.columns.2.w,
            
            m30: value.columns.3.x,
            m31: value.columns.3.y,
            m32: value.columns.3.z,
            m33: value.columns.3.w
        )
    }
    
    public init(
        m00: Float,
        m01: Float,
        m02: Float,
        m03: Float,
        m10: Float,
        m11: Float,
        m12: Float,
        m13: Float,
        m20: Float,
        m21: Float,
        m22: Float,
        m23: Float,
        m30: Float,
        m31: Float,
        m32: Float,
        m33: Float
    ) {
        self.m00 = m00
        self.m01 = m01
        self.m02 = m02
        self.m03 = m03
        self.m10 = m10
        self.m11 = m11
        self.m12 = m12
        self.m13 = m13
        self.m20 = m20
        self.m21 = m21
        self.m22 = m22
        self.m23 = m23
        self.m30 = m30
        self.m31 = m31
        self.m32 = m32
        self.m33 = m33
    }
}
