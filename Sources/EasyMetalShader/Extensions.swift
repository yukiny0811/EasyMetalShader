//
//  Extensions.swift
//
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import CoreGraphics
@_exported import MetalKit
@_exported import simd

extension CGPoint: AdditiveArithmetic {
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

extension MTLTexture {
    var cgImage: CGImage? {
        guard let ciimage = CIImage(mtlTexture: self) else {
            return nil
        }
        let flipped = ciimage.transformed(by: CGAffineTransform(scaleX: 1, y: -1))
        let cgimage = ShaderCore.context.createCGImage(
            flipped,
            from: flipped.extent
        )
        return cgimage
    }
}

