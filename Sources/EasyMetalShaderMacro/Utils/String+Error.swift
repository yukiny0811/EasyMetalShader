//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/12.
//

import Foundation

extension String: LocalizedError {
    public var errorDescription: String? { self }
}
