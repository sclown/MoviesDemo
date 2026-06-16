//
//  Store.swift
//

import Foundation

/// A pure state transition: given the current state and an incoming action,
/// mutate the state in place and return any side effects to run.
///
/// Reducers contain no asynchronous work and no I/O — everything observable
/// happens through the returned `Effect`, which keeps them trivially testable.
public typealias Reducer<State, Action> = @MainActor (_ state: inout State, _ action: Action) -> Effect<Action>

/// The runtime for The Elm Architecture: owns the state, runs the reducer for
/// every action, and interprets the effects the reducer returns (including the
/// lifecycle of their `Task`s).
///
/// Generalizes the former `ObservableState` — it is still `@Observable`, so
/// SwiftUI views re-render when `state` changes, and `didChange` is preserved
/// for test observation.
@MainActor
@Observable
public final class Store<State, Action> {
    public private(set) var state: State

    @ObservationIgnored private let reducer: Reducer<State, Action>

    // Maps a caller-supplied cancellation id to an internal token. Main-actor
    // only; never touched from `deinit` (AnyHashable is not Sendable).
    @ObservationIgnored private var tokensByID: [AnyHashable: Int] = [:]
    // The live tasks, keyed by internal token. This is Sendable, so the
    // nonisolated `deinit` may cancel everything still running.
    @ObservationIgnored private var openTasks: [Int: Task<Void, Never>] = [:]
    @ObservationIgnored private var nextToken = 0

    /// Called with the new state after every action is reduced. Used by tests
    /// to observe the stream of states.
    @ObservationIgnored public var didChange: ((State) -> Void)?

    public init(initialState: State, reducer: @escaping Reducer<State, Action>) {
        self.state = initialState
        self.reducer = reducer
    }

    deinit {
        for task in openTasks.values {
            task.cancel()
        }
    }

    /// Feed an action into the loop: reduce, notify observers, then run effects.
    public func send(_ action: Action) {
        let effect = reducer(&state, action)
        didChange?(state)
        run(effect)
    }

    private func run(_ effect: Effect<Action>) {
        switch effect.operation {
        case .none:
            break

        case let .cancel(id):
            cancel(id: id)

        case let .run(id, operation):
            if let id {
                cancel(id: id)
            }
            let token = nextToken
            nextToken += 1
            let send = Send<Action> { [weak self] action in
                self?.send(action)
            }
            let task = Task { @MainActor [weak self] in
                await operation(send)
                self?.openTasks[token] = nil
                if let id {
                    self?.tokensByID[id] = nil
                }
            }
            openTasks[token] = task
            if let id {
                tokensByID[id] = token
            }
        }
    }

    private func cancel(id: AnyHashable) {
        guard let token = tokensByID[id] else { return }
        openTasks[token]?.cancel()
        openTasks[token] = nil
        tokensByID[id] = nil
    }
}
