//
//  CGPoint+.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/06.
//

extension CGPoint: AdditiveArithmetic {
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
