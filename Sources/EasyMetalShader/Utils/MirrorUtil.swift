//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import Foundation

enum MirrorUtil {
    
    static func setInitialValue(for object: EMMetalFunction) {
        let mir = Mirror(reflecting: object).children
        let mirArray = Array(mir)
        for prop in mirArray {
            let propString = String(describing: prop.value.self)
            let filteredPropString = String(propString[propString.startIndex..<propString.index(propString.startIndex, offsetBy: 27)])
            if filteredPropString == "EasyMetalShader.EMArgument<" {
                if let label = prop.label {
                    let propLabel = String(label[label.index(label.startIndex, offsetBy: 1)..<label.endIndex]) //ex test
                    let typeString = String(propString[propString.index(propString.startIndex, offsetBy: 27)..<propString.index(propString.endIndex, offsetBy: -1)]) //ex Swift.Float
                    print(typeString)
                    print(propLabel)
                    object.setValue(EMMetalArgument.getInitialValue(of: prop.value, objTypeString: typeString), forKey: propLabel)
                }
            }
        }
    }
}
