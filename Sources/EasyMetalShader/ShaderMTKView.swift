//
//  ShaderMTKView.swift
//
//
//  Created by Yuki Kuwashima on 2024/01/04.
//

import MetalKit
import SwiftUI

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

public class ShaderMTKView: MTKView {
    
    let renderer: ShaderRenderer
    
    init(renderer: ShaderRenderer) {
        self.renderer = renderer
        super.init(frame: .zero, device: ShaderCore.device)
        
        self.frame = .zero
        self.delegate = renderer
        self.enableSetNeedsDisplay = false
        self.isPaused = false
        self.colorPixelFormat = .rgba8Unorm
        self.framebufferOnly = false
        self.preferredFramesPerSecond = 60
        self.autoResizeDrawable = true
        self.clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        self.sampleCount = 1
        self.clearDepth = 1.0
        
        #if os(macOS)
        let options: NSTrackingArea.Options = [
            .mouseMoved,
            .activeAlways,
            .inVisibleRect,
        ]
        let trackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
        #endif
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if os(macOS)
    public override func mouseDragged(with event: NSEvent) {
        let mousePos = mousePos(event: event, viewFrame: self.superview!.frame)
        renderer.mousePosition = mousePos
    }
    
    func mousePos(event: NSEvent, viewFrame: NSRect) -> simd_float2 {
        var location = event.locationInWindow
        location.y = event.window!.contentRect(
            forFrameRect: event.window!.frame
        ).height - location.y
        location -= CGPoint(x: viewFrame.minX, y: viewFrame.minY)
        return simd_float2(Float(location.x), Float(location.y))
    }
    #endif
}

#if os(macOS)
public struct EasyShaderView: NSViewRepresentable {
    
    let renderer: ShaderRenderer
    
    public init(renderer: ShaderRenderer) {
        self.renderer = renderer
    }
    
    public func makeNSView(context: Context) -> MTKView {
        let mtkView = ShaderMTKView(renderer: renderer)
        return mtkView
    }
    public func updateNSView(_ nsView: MTKView, context: Context) {}
}
#elseif os(iOS)
public struct EasyShaderView: UIViewRepresentable {
    
    let renderer: ShaderRenderer
    
    public init(renderer: ShaderRenderer) {
        self.renderer = renderer
    }
    
    public func makeUIView(context: Context) -> MTKView {
        let mtkView = ShaderMTKView(renderer: renderer)
        return mtkView
    }
    public func updateUIView(_ uiView: MTKView, context: Context) {}
}
#endif
