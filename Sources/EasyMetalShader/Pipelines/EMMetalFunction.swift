//
//  EMMetalFunction.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import Foundation

public protocol EMMetalFunction: NSObject {
    var args: [String: EMMetalArgument] { get set }
}
