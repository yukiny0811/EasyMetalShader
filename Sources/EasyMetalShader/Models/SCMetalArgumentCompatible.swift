//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import simd
import MetalKit

public protocol SCArgumentCompatible {}
extension Bool: SCArgumentCompatible {}
extension Int: SCArgumentCompatible {}
extension Float: SCArgumentCompatible {}
extension sc_int2: SCArgumentCompatible {}
extension sc_int3: SCArgumentCompatible {}
extension sc_int4: SCArgumentCompatible {}
extension sc_float2: SCArgumentCompatible {}
extension sc_float3: SCArgumentCompatible {}
extension sc_float4: SCArgumentCompatible {}
extension SCMetalTexture: SCArgumentCompatible {}
