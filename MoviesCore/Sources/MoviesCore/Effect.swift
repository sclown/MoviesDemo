//
//  Effect.swift
//

import Foundation

/// A handle a running effect uses to feed actions back into the store.
@MainActor
public struct Send<Action> {
    private let send: (Action) -> Void

    init(_ send: @escaping (Action) -> Void) {
        self.send = send
    }

    public func callAsFunction(_ action: Action) {
        send(action)
    }
}

/// A description of side effects produced by a reducer, run by the `Store`.
///
/// Effects are values: a reducer never performs work itself, it only returns
/// an `Effect` describing what should happen. The store interprets it.
public struct Effect<Action> {
    enum Operation {
        case none
        case run(id: AnyHashable?, operation: @MainActor (Send<Action>) async -> Void)
        case cancel(id: AnyHashable)
    }

    let operation: Operation

    private init(_ operation: Operation) {
        self.operation = operation
    }

    /// An effect that does nothing.
    public static var none: Effect {
        Effect(.none)
    }

    /// An asynchronous effect. Provide an `id` to make the work cancellable:
    /// starting another effect with the same `id` cancels the in-flight one.
    public static func run(
        id: AnyHashable? = nil,
        _ operation: @escaping @MainActor (Send<Action>) async -> Void
    ) -> Effect {
        Effect(.run(id: id, operation: operation))
    }

    /// Cancels any in-flight effect previously started with the given `id`.
    public static func cancel(id: AnyHashable) -> Effect {
        Effect(.cancel(id: id))
    }
}
