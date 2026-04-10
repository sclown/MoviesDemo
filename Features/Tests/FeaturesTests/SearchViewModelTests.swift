import Testing
import Foundation
@testable import Features
import MoviesApi
import NetworkService

private func makeJSON(ids: [Int], totalPages: Int) -> Data {
    let movies = ids.map { id in
        """
        {"id": \(id), "title": "Movie \(id)", "overview": "Overview", "poster_path": null, "release_date": null, "vote_average": 5.0}
        """
    }.joined(separator: ",")

    return """
    {"results": [\(movies)], "total_pages": \(totalPages)}
    """.data(using: .utf8)!
}

private struct StubNetworkClient: NetworkClient {
    var searchData: Data?
    var error: Error?

    func data(from url: URL) async throws -> Data {
        if let error { throw error }
        return searchData ?? Data()
    }
}

@MainActor
private func makeSearchViewModel(
    searchData: Data? = nil,
    error: Error? = nil,
    logger: TestStateLogger<SearchState>
) -> SearchViewModel {
    let client = StubNetworkClient(searchData: searchData, error: error)
    let service = MovieService(networkClient: client)
    return SearchViewModel(service: service, logger: logger.log)
}

@MainActor
struct SearchViewModelTests {
    @Test func searchDebouncesAndReturnsResults() async throws {
        let logger = TestStateLogger<SearchState>()
        let vm = makeSearchViewModel(
            searchData: makeJSON(ids: [10, 11], totalPages: 1),
            logger: logger
        )

        vm.updateSearchQuery("test")
        let searching = try await logger.next()
        let searched = try await logger.next()

        #expect(searching.isSearching == true)
        #expect(searched.isSearching == false)
        #expect(searched.searchResults.count == 2)
        #expect(searched.searchResults.first?.id == 10)
    }

    @Test func clearingSearchClearsResults() async throws {
        let logger = TestStateLogger<SearchState>()
        let vm = makeSearchViewModel(
            searchData: makeJSON(ids: [10], totalPages: 1),
            logger: logger
        )

        vm.updateSearchQuery("test")
        try await logger.collect(count: 1)
        let searched = try await logger.next()
        #expect(searched.searchResults.count == 1)

        vm.updateSearchQuery("")
        let cleared = try await logger.next()

        #expect(cleared.searchResults.isEmpty)
        #expect(cleared.searchQuery.isEmpty)
    }
}
