//
//  EMArgumentCompatible.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import simd
import MetalKit

public protocol EMArgumentCompatible {}
extension Bool: EMArgumentCompatible {}
extension Int32: EMArgumentCompatible {}
extension Float: EMArgumentCompatible {}
extension em_int2: EMArgumentCompatible {}
extension em_int3: EMArgumentCompatible {}
extension em_int4: EMArgumentCompatible {}
extension em_float2: EMArgumentCompatible {}
extension em_float3: EMArgumentCompatible {}
extension em_float4: EMArgumentCompatible {}
extension EMMetalTexture: EMArgumentCompatible {}
