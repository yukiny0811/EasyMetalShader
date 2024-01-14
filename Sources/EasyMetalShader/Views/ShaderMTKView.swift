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
        self.colorPixelFormat = .bgra8Unorm
        self.framebufferOnly = false
        self.preferredFramesPerSecond = 60
        self.autoResizeDrawable = true
        self.clearColor = .init(red: 0, green: 0, blue: 0, alpha: 0)
        self.sampleCount = 1
        self.clearDepth = 1.0
        
        #if os(macOS)
        self.layer?.isOpaque = false
        #elseif os(iOS)
        self.layer.isOpaque = false
        #endif
        
        #if os(macOS)
        let options: NSTrackingArea.Options = [
            .mouseMoved,
            .activeAlways,
            .inVisibleRect,
        ]
        let trackingArea = NSTrackingArea(rect: bounds, options: options, owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
        #endif
        
        #if os(iOS)
        let scrollGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onScroll))
        scrollGestureRecognizer.allowedScrollTypesMask = .continuous
        scrollGestureRecognizer.minimumNumberOfTouches = 2
        scrollGestureRecognizer.maximumNumberOfTouches = 2
        self.addGestureRecognizer(scrollGestureRecognizer)
        #endif
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        #if os(iOS)
        if let recognizers = self.gestureRecognizers {
            for recognizer in recognizers {
                self.removeGestureRecognizer(recognizer)
            }
        }
        #endif
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
    
    #if os(iOS)
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.touchesBegan(touches, with: event, view: self)
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.touchesMoved(touches, with: event, view: self)
    }
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.touchesEnded(touches, with: event, view: self)
    }
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.touchesCancelled(touches, with: event, view: self)
    }
    @objc func onScroll(recognizer: UIPanGestureRecognizer) {
        renderer.onScroll(recognizer: recognizer, view: self)
    }
    #endif
}
