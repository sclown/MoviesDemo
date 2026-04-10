import Foundation
@testable import Features

struct TestLoggerTimeout: Error {}

final class TestStateLogger<State: Sendable>: @unchecked Sendable {
    let events: AsyncStream<State>
    private let continuation: AsyncStream<State>.Continuation

    init() {
        let (stream, continuation) = AsyncStream.makeStream(of: State.self)
        self.events = stream
        self.continuation = continuation
    }

    var log: StateLogger<State> {
        { [continuation] state in
            continuation.yield(state)
        }
    }

    deinit {
        continuation.finish()
    }

    func next() async throws -> State {
        let events = try await collect(count: 1)
        guard let first = events.first else { throw TestLoggerTimeout() }
        return first
    }

    @discardableResult
    func collect(count: Int, timeout: Duration = .seconds(2)) async throws -> [State] {
        try await withThrowingTaskGroup(of: [State].self) { group in
            group.addTask {
                var collected: [State] = []
                var iterator = self.events.makeAsyncIterator()
                for _ in 0..<count {
                    guard let event = await iterator.next() else { break }
                    collected.append(event)
                }
                return collected
            }
            group.addTask {
                try? await Task.sleep(for: timeout)
                return []
            }
            let result = try await group.next()!
            group.cancelAll()
            if result.count < count {
                throw TestLoggerTimeout()
            }
            return result
        }
    }
}
