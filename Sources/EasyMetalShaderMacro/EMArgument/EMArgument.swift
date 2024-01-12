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

public struct EMArgument: AccessorMacro {
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
        guard let initialValue = binding.initializer?.value else {
            throw "rrr"
        }
        
        var setString: String? = nil
        
        switch type.trimmedDescription {
        case "Float":
            setString = ".float(\(variableName))"
        default:
            return []
        }
        
        guard let setString else { return [] }
        
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
