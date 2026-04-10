import Testing
import Foundation
@testable import NetworkService

struct NetworkErrorTests {
    @Test func mapsNotConnectedToInternet() {
        let error = NetworkError(urlError: URLError(.notConnectedToInternet))
        #expect(error == .noConnection)
    }

    @Test func mapsDataNotAllowed() {
        let error = NetworkError(urlError: URLError(.dataNotAllowed))
        #expect(error == .noConnection)
    }

    @Test func mapsConnectionLost() {
        let error = NetworkError(urlError: URLError(.networkConnectionLost))
        #expect(error == .connectionLost)
    }

    @Test func mapsTimedOut() {
        let error = NetworkError(urlError: URLError(.timedOut))
        #expect(error == .timeout)
    }

    @Test func returnsNilForUnknownCode() {
        let error = NetworkError(urlError: URLError(.badURL))
        #expect(error == nil)
    }

    @Test func noConnectionDescription() {
        #expect(NetworkError.noConnection.errorDescription == "No internet connection. Please check your network settings.")
    }

    @Test func connectionLostDescription() {
        #expect(NetworkError.connectionLost.errorDescription == "The connection was lost. Please try again.")
    }

    @Test func timeoutDescription() {
        #expect(NetworkError.timeout.errorDescription == "The request timed out. Please try again.")
    }

    @Test func httpErrorDescription() {
        #expect(NetworkError.httpError(404).errorDescription == "Server returned an error (HTTP 404).")
        #expect(NetworkError.httpError(500).errorDescription == "Server returned an error (HTTP 500).")
    }

    @Test func httpErrorEquality() {
        #expect(NetworkError.httpError(401) == .httpError(401))
        #expect(NetworkError.httpError(401) != .httpError(500))
    }
}
