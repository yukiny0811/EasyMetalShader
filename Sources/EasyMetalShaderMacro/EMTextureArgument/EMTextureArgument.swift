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
        
        guard let args = node.arguments?.as(LabeledExprListSyntax.self) else {
            throw "invalid argument"
        }
        
        guard let usage = args.first?.as(LabeledExprSyntax.self)?.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.trimmedDescription else {
            throw "invalid texture usage"
        }
        
        var format: String?
        
        if args.count >= 2 {
            format = args[args.index(args.startIndex, offsetBy: 1)].as(LabeledExprSyntax.self)?.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.trimmedDescription
        }
            
        guard type.trimmedDescription == "MTLTexture?" else {
            throw "type \(type) is not supported for EMTextureArgument."
        }
        
        guard let setString = Util.textureTypeToArgumentString(textureType: type.trimmedDescription, variableName: variableName, usage: usage, format: format) else {
            throw "textureType \(format ?? "nil") is not supported for EMTextureArgument."
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
