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
            return [
                AttributeSyntax(
                    attributeName: IdentifierTypeSyntax(
                        name: .identifier("ShaderStringBuilder")
                    )
                )
            ]
        }
        if binding.pattern.description == "customMetalCode" {
            return [
                AttributeSyntax(
                    attributeName: IdentifierTypeSyntax(
                        name: .identifier("ShaderStringBuilder")
                    )
                )
            ]
        }
        
        guard let type = binding.typeAnnotation?.type else {
            throw "needs concrete type declaration for EMArgument. Use @EMIgnore to ignore argument."
        }
        
        for attribute in varDecl.attributes {
            if let attributeName = attribute.as(AttributeSyntax.self)?.attributeName.trimmedDescription {
                if attributeName == "EMTextureArgument" || attributeName == "EMIgnore" {
                    return []
                }
            }
        }
        
        if type.trimmedDescription == "MTLTexture?" {
            return [
                AttributeSyntax(
                    attributeName: IdentifierTypeSyntax(
                        name: .identifier("EMTextureArgument(.read_write, .type2D)")
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
