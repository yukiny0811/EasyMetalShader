//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import Foundation

@attached(accessor, names: named(didSet))
public macro EMArgument() = #externalMacro(module: "EasyMetalShaderMacro", type: "EMArgument")
