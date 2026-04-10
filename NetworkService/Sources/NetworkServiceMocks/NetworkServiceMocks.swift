//
// NetworkServiceMocks
//

import Foundation

@testable import NetworkService

@MainActor //simplest actor protection
public final class MockNetworkClient: NetworkClient {
    public var result: Result<Data, Error>
    
    public init(result: Result<Data, Error>) {
        self.result = result
    }

    public func data(from url: URL) async throws -> Data {
        try result.get()
    }
}
