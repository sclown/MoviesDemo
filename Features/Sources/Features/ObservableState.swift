//
//  ObservableState.swift
//

import Foundation

@Observable
final class ObservableState<Value> {
    var value: Value {
        didSet {
            didChange?(value)
        }
    }
    
    var didChange: ((Value) -> Void)?

    init(_ value: Value) {
        self.value = value
    }
}
