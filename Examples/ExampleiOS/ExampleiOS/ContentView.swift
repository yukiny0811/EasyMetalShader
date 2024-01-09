//
//  ContentView.swift
//  ExampleiOS
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import SwiftUI
import EasyMetalShader

struct ContentView: View {
    let renderer = MyRenderer()
    var body: some View {
        EasyShaderView(renderer: renderer)
    }
}
