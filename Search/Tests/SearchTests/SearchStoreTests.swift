import Testing
import Foundation
@testable import Search
import MoviesApi
import MoviesCore
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
private func makeStore(
    searchData: Data? = nil,
    error: Error? = nil,
    navigation: @escaping (MovieDetails) -> Void = { _ in },
    logger: TestStateLogger<SearchState>
) -> SearchStore {
    let client = StubNetworkClient(searchData: searchData, error: error)
    let service = MovieService(networkClient: client)
    let store = SearchStore(
        initialState: .empty,
        reducer: searchReducer(service: service, navigation: navigation)
    )
    store.didChange = logger.log
    return store
}

@MainActor
struct SearchStoreTests {
    @Test func searchDebouncesAndReturnsResults() async throws {
        let logger = TestStateLogger<SearchState>()
        let store = makeStore(
            searchData: makeJSON(ids: [10, 11], totalPages: 1),
            logger: logger
        )

        store.send(.queryChanged("test"))
        let searching = try await logger.next()
        let searched = try await logger.next()

        #expect(searching.isSearching == true)
        #expect(searched.isSearching == false)
        #expect(searched.searchResults.count == 2)
        #expect(searched.searchResults.first?.id == 10)
    }

    @Test func clearingSearchClearsResults() async throws {
        let logger = TestStateLogger<SearchState>()
        let store = makeStore(
            searchData: makeJSON(ids: [10], totalPages: 1),
            logger: logger
        )

        store.send(.queryChanged("test"))
        try await logger.collect(count: 1)
        let searched = try await logger.next()
        #expect(searched.searchResults.count == 1)

        store.send(.queryChanged(""))
        let cleared = try await logger.next()

        #expect(cleared.searchResults.isEmpty)
        #expect(cleared.searchQuery.isEmpty)
    }

    @Test func resultTapInvokesCallback() async throws {
        let logger = TestStateLogger<SearchState>()
        var navigated: MovieDetails?
        let store = makeStore(
            searchData: makeJSON(ids: [42], totalPages: 1),
            navigation: { navigated = $0 },
            logger: logger
        )

        store.send(.queryChanged("test"))
        _ = try await logger.collect(count: 2)

        store.send(.resultTapped(id: 42))

        #expect(navigated?.id == 42)
    }
}
