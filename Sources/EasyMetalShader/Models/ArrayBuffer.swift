//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/08/01.
//

import MetalKit
import simd

extension String: LocalizedError {
    public var errorDescription: String? { self }
}

public class BoolBuffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<Bool>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [Bool]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<Bool>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [Bool] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: Bool.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}

public class IntBuffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<Int32>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [Int32]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<Int32>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [Int32] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: Int32.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}

public class Int2Buffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<simd_int2>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [simd_int2]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<simd_int2>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [simd_int2] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: simd_int2.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}

public class Int3Buffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<simd_int3>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [simd_int3]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<simd_int3>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [simd_int3] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: simd_int3.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}

public class Int4Buffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<simd_int4>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [simd_int4]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<simd_int4>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [simd_int4] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: simd_int4.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}

public class FloatBuffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<Float>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [Float]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<Float>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [Float] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: Float.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}

public class Float2Buffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<simd_float2>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [simd_float2]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<simd_float2>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [simd_float2] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: simd_float2.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}

public class Float3Buffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<simd_float3>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [simd_float3]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<simd_float3>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [simd_float3] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: simd_float3.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}

public class Float4Buffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<simd_float4>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [simd_float4]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<simd_float4>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [simd_float4] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: simd_float4.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}

public class DoubleBuffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<Double>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [Double]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<Double>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [Double] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: Double.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}

public class Double2Buffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<simd_double2>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [simd_double2]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<simd_double2>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [simd_double2] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: simd_double2.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}

public class Double3Buffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<simd_double3>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [simd_double3]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<simd_double3>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [simd_double3] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: simd_double3.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}

public class Double4Buffer {

    public var buffer: MTLBuffer
    public let count: Int

    public init(count: Int) {
        self.buffer = ShaderCore_EasyMetalShaderLib.device.makeBuffer(length: MemoryLayout<simd_double4>.stride * count)!
        self.count = count
    }

    @discardableResult
    public func setBytes(_ bytes: [simd_double4]) throws -> Self {
        guard bytes.count == count else {
            throw "byte count is wrong"
        }
        self.buffer
            .contents()
            .copyMemory(
                from: bytes,
                byteCount: MemoryLayout<simd_double4>.stride * count
            )
        return self
    }

    /// this can be super heavy to call.
    public func readBytes() -> [simd_double4] {
        let arrayPointer = buffer.contents().assumingMemoryBound(to: simd_double4.self)
        return Array(UnsafeBufferPointer(start: arrayPointer, count: count))
    }
}
