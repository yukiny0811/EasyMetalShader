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

extension EMComputeShader: MemberAttributeMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingAttributesFor member: some SwiftSyntax.DeclSyntaxProtocol,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.AttributeSyntax] {
        
        guard let varDecl = member.as(VariableDeclSyntax.self) else {
            return []
        }
        
        let patternBindingList = varDecl.bindings
        
        guard let binding = patternBindingList.first else {
            return []
        }
        
        if binding.pattern.description == "impl" {
            return []
        }
        if binding.pattern.description == "customMetalCode" {
            return []
        }
        
        guard let type = binding.typeAnnotation?.type else {
            throw "wow error"
        }
        
        if type.trimmedDescription == "MTLTexture?" {
            for attribute in varDecl.attributes {
                if let attributeName = attribute.as(AttributeSyntax.self)?.attributeName.trimmedDescription {
                    if attributeName == "EMTextureArgument" {
                        return []
                    }
                }
            }
            return [
                AttributeSyntax(
                    attributeName: IdentifierTypeSyntax(
                        name: .identifier("EMTextureArgument(.read_write)")
                    )
                )
            ]
        } else {
            return [
                AttributeSyntax(
                    attributeName: IdentifierTypeSyntax(
                        name: .identifier("EMArgument")
                    )
                )
            ]
        }
    }
}
