//
//  EasyShaderView.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/06.
//

import MetalKit
import SwiftUI

#if os(macOS)
import AppKit
#elseif os(iOS)
import UIKit
#endif

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
