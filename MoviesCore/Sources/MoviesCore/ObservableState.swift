//
//  ObservableState.swift
//

import Foundation

@Observable
public final class ObservableState<Value> {
    public var value: Value {
        didSet {
            didChange?(value)
        }
    }

    public var didChange: ((Value) -> Void)?

    public init(_ value: Value) {
        self.value = value
    }
}
