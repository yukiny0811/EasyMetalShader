//
//  File.swift
//  
//
//  Created by Yuki Kuwashima on 2024/01/09.
//

import MetalKit
import Foundation

@propertyWrapper
public class EMArgument<Value: SCArgumentCompatible> {
    
    private var value: Value
    private let key: String
    
    public let initialValue: Value
    
    @available(*, unavailable, message: "should not be called")
    public var wrappedValue: Value {
        get { value }
        set { value = newValue }
    }
    
    public init(wrappedValue: Value, _ key: String){
        self.value = wrappedValue
        self.key = key
        self.initialValue = wrappedValue
    }
    
    public static subscript<EnclosingSelf: SCMetalFunction>(
        _enclosingInstance object: EnclosingSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<EnclosingSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<EnclosingSelf, EMArgument>
    ) -> Value {
        get {
            return object[keyPath: storageKeyPath].value
        }
        set {
            object[keyPath: storageKeyPath].value = newValue
            let thisKey = object[keyPath: storageKeyPath].key
            object.args[thisKey] = SCMetalArgument.getMetalArgument(from: object[keyPath: storageKeyPath].value)
        }
    }
}
