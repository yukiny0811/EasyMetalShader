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

extension EMComputeShader: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        if protocols.isEmpty { return [] }
        
        var initStringList: [String] = []
        
        let memberBlock = declaration.memberBlock
        let memberBlockItemList = memberBlock.members
        for memberBlockItem in memberBlockItemList {
            if let variableDecl = memberBlockItem.decl.as(VariableDeclSyntax.self) {
                if let binding = variableDecl.bindings.first {
                    let variableName = binding.pattern.trimmedDescription
                    if let type = binding.typeAnnotation?.type, let initialValue = binding.initializer?.value {
                        switch type.trimmedDescription {
                        case "Float":
                            initStringList.append("args[\"\(variableName)\"] = .float(\(initialValue))")
                        case "MTLTexture?":
                            var usage: String? = nil
                            for element in variableDecl.attributes {
                                if let attribute = element.as(AttributeSyntax.self) {
                                    if attribute.attributeName.trimmedDescription == "EMTextureArgument" {
                                        if let args = attribute.arguments {
                                            usage = args.trimmedDescription
                                        }
                                    }
                                }
                            }
                            if let usage {
                                initStringList.append("args[\"\(variableName)\"] = .texture2d(\(initialValue), \(usage))")
                            }
                        default:
                            continue
                        }
                    }
                }
            }
        }
        
        let thisDecl1: DeclSyntax =
        """
        var computePipelineState: MTLComputePipelineState!
        """
        
        let thisDecl2: DeclSyntax =
        """
        var args: [String: EMMetalArgument] = [:]
        """
        
        let thisDecl3: DeclSyntax = .init(stringLiteral: ComputeFunctionStrings.initFunc(variableInitStrings: initStringList))
        
        let thisDecl4: DeclSyntax = .init(stringLiteral: ComputeFunctionStrings.dispatchFunc)
        
        return [thisDecl1, thisDecl2, thisDecl3, thisDecl4]
    }
    
}
