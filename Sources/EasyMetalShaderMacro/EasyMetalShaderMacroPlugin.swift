//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct EasyMetalShaderMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        EMComputeShader.self,
        EMRenderShader.self,
        EMArgument.self,
        EMTextureArgument.self,
    ]
}

