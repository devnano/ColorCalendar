//
//  Lazy.swift
//  https://stackoverflow.com/a/25761153
//

import Foundation

class Lazy<T> {
    private let _initializer: () -> T
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
    
    required init(initializer: @escaping () -> T) {
        self._initializer = initializer
    }
}
