import Testing
import Foundation
import NetworkService
import NetworkServiceMocks
import MoviesApiMocks

@testable import MoviesApi

@MainActor
struct MovieServiceTests {
    @Test func fetchReturnsMovies() async throws {
        let client = MockNetworkClient(result: .success(.validList))
        let service = MovieService(networkClient: client)

        let response = try await service.fetchPopularMovies(page: 1)

        #expect(response.results.count == 1)
        #expect(response.results[0].title == "Test Movie 1")
    }

    @Test func fetchPropagatesNetworkError() async {
        let client = MockNetworkClient(result: .failure(NetworkError.noConnection))
        let service = MovieService(networkClient: client)

        await #expect(throws: NetworkError.self) {
            try await service.fetchPopularMovies(page: 1)
        }
    }

    @Test func fetchPropagatesParseError() async {
        let client = MockNetworkClient(result: .success(.invalidDataList))
        let service = MovieService(networkClient: client)

        await #expect(throws: (any Error).self) {
            try await service.fetchPopularMovies(page: 1)
        }
    }
}
