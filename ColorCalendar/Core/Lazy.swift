//
//  Lazy.swift
//  https://stackoverflow.com/a/25761153
//

import Foundation

public class Lazy<T> {
    private let _initializer: () -> T
    // TODO: this should be weak
    private var _value: T?
    var value: T! {
        get {
            if self._value == nil {
                self._value = self._initializer()
            }
            return self._value
        }
        set {
            self._value = newValue
        }
    }
    
    public required init(_ initializer: @escaping () -> T) {
        self._initializer = initializer
    }
}
