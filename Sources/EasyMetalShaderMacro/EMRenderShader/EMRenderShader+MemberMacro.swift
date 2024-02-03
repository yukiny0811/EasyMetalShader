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

extension EMRenderShader: MemberMacro {
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        conformingTo protocols: [TypeSyntax],
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        if protocols.isEmpty { return [] }
        
        var initStringList: [String] = []
        
        var hasInitInImplementation = false
        var hasVertImpl = false
        var hasFragImpl = false
        var hasMetalCode = false
        
        let memberBlock = declaration.memberBlock
        let memberBlockItemList = memberBlock.members
        for memberBlockItem in memberBlockItemList {
            if let variableDecl = memberBlockItem.decl.as(VariableDeclSyntax.self) {
                
                var ignore = false
                for element in variableDecl.attributes {
                    if let attribute = element.as(AttributeSyntax.self) {
                        if attribute.attributeName.trimmedDescription == "EMIgnore" {
                            ignore = true
                        }
                    }
                }
                if ignore {
                    continue
                }
                
                if let binding = variableDecl.bindings.first {
                    let variableName = binding.pattern.trimmedDescription
                    
                    if variableName == "vertImpl" {
                        hasVertImpl = true
                        continue
                    }
                    if variableName == "fragImpl" {
                        hasFragImpl = true
                        continue
                    }
                    if variableName == "customMetalCode" {
                        hasMetalCode = true
                        continue
                    }
                    
                    if let type = binding.typeAnnotation?.type {
                        if type.trimmedDescription == "MTLTexture?" {
                            var usage: String? = nil
                            var format: String? = nil
                            for element in variableDecl.attributes {
                                if let attribute = element.as(AttributeSyntax.self) {
                                    if attribute.attributeName.trimmedDescription == "EMTextureArgument" {
                                        if let args = attribute.arguments?.as(LabeledExprListSyntax.self) {
                                            usage = args.first?.as(LabeledExprSyntax.self)?.expression.as(MemberAccessExprSyntax.self)?.declName.baseName.trimmedDescription
                                            if args.count >= 2 {
                                                format = args[args.index(args.startIndex, offsetBy: 1)].as(LabeledExprSyntax.self)?.expression.as(
                                                    MemberAccessExprSyntax.self
                                                )?.declName.baseName.trimmedDescription
                                            }
                                        }
                                        
                                    }
                                }
                            }
                            if let usage {
                                if let setString = Util.textureTypeToArgumentString(textureType: type.trimmedDescription, variableName: variableName, usage: usage, format: format) {
                                    initStringList.append("args[\"\(variableName)\"] = \(setString)")
                                }
                            } else {
                                if let setString = Util.textureTypeToArgumentString(textureType: type.trimmedDescription, variableName: variableName, usage: "read_write", format: format) {
                                    initStringList.append("args[\"\(variableName)\"] = \(setString)")
                                }
                            }
                        } else {
                            if let setString = Util.typeToArgumentString(type: type.trimmedDescription, variableName: variableName) {
                                initStringList.append("args[\"\(variableName)\"] = \(setString)")
                            }
                        }
                    }
                }
            }
            if let initDecl = memberBlockItem.decl.as(InitializerDeclSyntax.self) {
                hasInitInImplementation = true
                var isSetupCalled = false
                if let block = initDecl.body {
                    for blockItem in block.statements {
                        if let functionCall = blockItem.item.as(FunctionCallExprSyntax.self) {
                            if let declReference = functionCall.calledExpression.as(DeclReferenceExprSyntax.self) {
                                if declReference.baseName.text == "setup" {
                                    isSetupCalled = true
                                }
                            }
                            if let memberAccessExpr = functionCall.calledExpression.as(MemberAccessExprSyntax.self) {
                                let declName = memberAccessExpr.declName
                                if declName.baseName.text == "setup" {
                                    isSetupCalled = true
                                }
                            }
                        }
                    }
                }
                if isSetupCalled == false {
                    throw "call setup(targetPixelFormat:) inside init()."
                }
            }
        }
        
        if !hasVertImpl {
            throw "implement var vertImpl: String { get }"
        }
        
        if !hasFragImpl {
            throw "implement var fragImpl: String { get }"
        }
        
        if !hasMetalCode {
            throw "implement var customMetalCode: String { get }"
        }
        
        let thisDecl1: DeclSyntax =
        """
        public var renderPipelineState: MTLRenderPipelineState!
        """
        
        let thisDecl2: DeclSyntax =
        """
        public var args: [String: EMMetalArgument] = [:]
        """
        
        let thisDecl3: DeclSyntax = .init(stringLiteral: RenderFunctionStrings.initFunc(variableInitStrings: initStringList))
        
        
        var thisDecl4: DeclSyntax = ""
        if !hasInitInImplementation {
            thisDecl4 =
            """
            public init(targetPixelFormat: MTLPixelFormat) {
                setup(targetPixelFormat: targetPixelFormat)
            }
            """
        }
        
        return [thisDecl1, thisDecl2, thisDecl3, thisDecl4]
    }
    
}
