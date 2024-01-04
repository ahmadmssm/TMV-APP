//
//  PublishedObject.swift
//  iosApp
//
//  Created by Ahmad Mahmoud on 10/11/2023.
//  Copyright © 2023 orgName. All rights reserved.
//

import Combine

// Ref: https://fatbobman.medium.com/adding-published-like-capability-to-custom-property-wrapper-types-d8af73d605b
@propertyWrapper
struct PublishedObject<Value: ObservableObject> { // wrappedValue requires to conform to ObservableObject
    
    var wrappedValue: Value
    private var cancellable: AnyCancellable?
    
    init(wrappedValue: Value) {
        self.wrappedValue = wrappedValue
    }
    
    static subscript<OuterSelf: ObservableObject>(
        _enclosingInstance observed: OuterSelf,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<OuterSelf, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<OuterSelf, Self>
    ) -> Value where OuterSelf.ObjectWillChangePublisher == ObservableObjectPublisher {
        get {
            if observed[keyPath: storageKeyPath].cancellable == nil {
                // This is executed only once.
                observed[keyPath: storageKeyPath].setup(observed)
            }
            return observed[keyPath: storageKeyPath].wrappedValue
        }
        set {
            observed.objectWillChange.send() // willSet
            observed[keyPath: storageKeyPath].wrappedValue = newValue
        }
    }
    
    // Subscribe to objectWillChange of wrappedvalue.
    // When wrappedValue sends a notification, call the _enclosingInstance's objectWillChange.send().
    // Use a closure to weakly reference _enclosingInstance.
    private mutating func setup<OuterSelf: ObservableObject>(_ enclosingInstance: OuterSelf) where OuterSelf.ObjectWillChangePublisher == ObservableObjectPublisher {
        cancellable = wrappedValue.objectWillChange.sink(receiveValue: { [weak enclosingInstance] _ in
            (enclosingInstance?.objectWillChange)?.send()
        })
    }
}
