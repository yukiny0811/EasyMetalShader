//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import Foundation

public protocol SCMetalFunction: NSObject {
    var args: [String: SCMetalArgument] { get set }
}
