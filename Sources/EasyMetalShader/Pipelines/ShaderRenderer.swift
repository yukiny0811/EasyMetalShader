//
//  ShaderRenderer.swift
//
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import MetalKit
import simd

open class ShaderRenderer: NSObject, MTKViewDelegate {
    
    public var mousePosition: simd_float2 = .zero
    public var date = Date()
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
    
    public func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {
            return
        }
        view.drawableSize = CGSize(width: view.frame.size.width * 2, height: view.frame.size.height * 2)
        draw(view: view, drawable: drawable)
    }
    
    open func draw(view: MTKView, drawable: CAMetalDrawable) {}
}
