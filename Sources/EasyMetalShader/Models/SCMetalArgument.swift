//
//  SCMetalArgument.swift
//
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import simd
import MetalKit

public enum SCMetalArgument: CaseIterable {
    
    public static var allCases: [SCMetalArgument] = [
        .bool(false),
        .int(0),
        .int2(.zero),
        .int3(.zero),
        .int4(.zero),
        .float(0),
        .float2(.zero),
        .float3(.zero),
        .float4(.zero),
        .texture2d(nil, .read),
    ]
    
    case bool(Bool)
    case int(Int32)
    case int2(simd_int2)
    case int3(simd_int3)
    case int4(simd_int4)
    case float(Float)
    case float2(simd_float2)
    case float3(simd_float3)
    case float4(simd_float4)
    case texture2d(MTLTexture!, SCMetalTextureUsage)
    
    static func getInitialValue(of obj: Any, objTypeString: String) -> SCArgumentCompatible? {
        switch objTypeString {
        case "Swift.Bool":
            return (obj as? EMArgument<Bool>)?.initialValue
        case "Swift.Int":
            return (obj as? EMArgument<Int>)?.initialValue
        case "EasyMetalShader.sc_int2":
            return (obj as? EMArgument<sc_int2>)?.initialValue
        case "EasyMetalShader.sc_int3":
            return (obj as? EMArgument<sc_int3>)?.initialValue
        case "EasyMetalShader.sc_int4":
            return (obj as? EMArgument<sc_int4>)?.initialValue
        case "EasyMetalShader.sc_float2":
            return (obj as? EMArgument<sc_float2>)?.initialValue
        case "EasyMetalShader.sc_float3":
            return (obj as? EMArgument<sc_float3>)?.initialValue
        case "EasyMetalShader.sc_float4":
            return (obj as? EMArgument<sc_float4>)?.initialValue
        case "Swift.Float":
            return (obj as? EMArgument<Float>)?.initialValue
        case "EasyMetalShader.SCMetalTexture":
            return (obj as? EMArgument<SCMetalTexture>)?.initialValue
        default:
            return nil
        }
    }
    
    static func getMetalArgument<Value>(from instance: Value) -> SCMetalArgument? {
        switch instance {
        case is Float:
            return .float(instance as! Float)
        case is Bool:
            return .bool(instance as! Bool)
        case is Int32:
            return .int(instance as! Int32)
        case is sc_int2:
            let i = instance as! sc_int2
            return .int2(simd_int2(i.x, i.y))
        case is sc_int3:
            let i = instance as! sc_int3
            return .int3(simd_int3(i.x, i.y, i.z))
        case is sc_int4:
            let i = instance as! sc_int4
            return .int4(simd_int4(i.x, i.y, i.z, i.w))
        case is sc_float2:
            let i = instance as! sc_float2
            return .float2(simd_float2(i.x, i.y))
        case is sc_float3:
            let i = instance as! sc_float3
            return .float3(simd_float3(i.x, i.y, i.z))
        case is sc_float4:
            let i = instance as! sc_float4
            return .float4(simd_float4(i.x, i.y, i.z, i.w))
        case is SCMetalTexture:
            let i = instance as! SCMetalTexture
            return .texture2d(i.texture, i.usage)
        default:
            return nil
        }
    }
}

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

@objcMembers
public class sc_int2: NSObject {
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

@objcMembers
public class sc_int3: NSObject {
    public var x: Int32
    public var y: Int32
    public var z: Int32
    public var simdValue: simd_int3 {
        return .init(x, y, z)
    }
    public init(_ x: Int32, _ y: Int32, _ z: Int32) {
        self.x = x
        self.y = y
        self.z = z
    }
}

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

@objcMembers
public class sc_float2: NSObject {
    public var x: Float
    public var y: Float
    public var simdValue: simd_float2 {
        return .init(x, y)
    }
    public init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
}

@objcMembers
public class sc_float3: NSObject {
    public var x: Float
    public var y: Float
    public var z: Float
    public var simdValue: simd_float3 {
        return .init(x, y, z)
    }
    public init(_ x: Float, _ y: Float, _ z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
}

@objcMembers
public class sc_float4: NSObject {
    public var x: Float
    public var y: Float
    public var z: Float
    public var w: Float
    public var simdValue: simd_float4 {
        return .init(x, y, z, w)
    }
    public init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
}
