//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/08/01.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct EMBufferArgument: AccessorMacro {

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
            throw "needs concrete type declaration for EMArgument."
        }

        guard let setString = Util.typeToArgumentString(type: type.trimmedDescription, variableName: variableName) else {
            throw "type \(type) is not supported for EMArgument."
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
