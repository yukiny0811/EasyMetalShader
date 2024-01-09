//
//  ShaderStringBuilder.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import Foundation

@resultBuilder
public struct ShaderStringBuilder {
    public static func buildBlock(_ component: String) -> String{
        component
    }
    public static func buildBlock(_ components: String...) -> String {
        components.joined()
    }
    public static func buildBlock(_ components: [String]) -> String {
        components.joined()
    }
    public static func buildBlock(_ components: [String], _ components2: [String]) -> String {
        components.joined() + components2.joined()
    }
    public static func buildArray(_ components: [String]) -> String {
        components.joined()
    }
    public static func buildArray(_ components: [[String]]) -> String {
        components.joined().joined()
    }
}
