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

public struct EMTextureArgument: AccessorMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        providingAccessorsOf declaration: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AccessorDeclSyntax] {
        guard let varDecl = declaration.as(VariableDeclSyntax.self) else {
            return []
        }
        let patternBindingList = varDecl.bindings
        
        guard let binding = patternBindingList.first else {
            return []
        }
        
        let variableName = binding.pattern.trimmedDescription
        guard let type = binding.typeAnnotation?.type else {
            throw "wow error"
        }
        
        guard let usage = node.arguments?.trimmedDescription else {
            throw "invalid texture usage"
        }
        
        guard let setString = Util.textureTypeToArgumentString(textureType: type.trimmedDescription, variableName: variableName, usage: usage) else {
            throw "type \(type) is not supported for EMTextureArgument."
        }
        
        let didSetString =
"""
didSet {
    args["\(variableName)"] = \(setString)
}
"""
        return [
            AccessorDeclSyntax(
                stringLiteral: didSetString
            )
        ]
    }
}
