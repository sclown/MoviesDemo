import ComposableArchitecture
import Testing
import MoviesApi
import MoviesApiMocks
import MoviesCore
@testable import Search

@MainActor
struct SearchFeatureTests {
    @Test func searchDebouncesAndReturnsResults() async {
        let clock = TestClock()
        let store = TestStore(initialState: SearchFeature.State()) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.movieClient.searchMovies = { _, _ in
                .mock(results: [.mockWith(id: 10), .mockWith(id: 11)], totalPages: 1)
            }
        }

        await store.send(.queryChanged("test")) {
            $0.query = "test"
            $0.isSearching = true
        }

        await clock.advance(by: .milliseconds(500))
        await store.receive(\.searchResponse.success) {
            $0.isSearching = false
            $0.results = [.mockWith(id: 10), .mockWith(id: 11)]
        }
    }

    @Test func clearingQueryClearsResults() async {
        let clock = TestClock()
        let store = TestStore(initialState: SearchFeature.State()) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.movieClient.searchMovies = { _, _ in
                .mock(results: [.mockWith(id: 10)], totalPages: 1)
            }
        }

        await store.send(.queryChanged("test")) {
            $0.query = "test"
            $0.isSearching = true
        }
        await clock.advance(by: .milliseconds(500))
        await store.receive(\.searchResponse.success) {
            $0.isSearching = false
            $0.results = [.mockWith(id: 10)]
        }

        await store.send(.queryChanged("")) {
            $0.query = ""
            $0.results = []
            $0.isSearching = false
        }
    }

    @Test func emptyResultsShowEmptyLabel() async {
        let clock = TestClock()
        let store = TestStore(initialState: SearchFeature.State()) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.movieClient.searchMovies = { _, _ in .mock(results: [], totalPages: 1) }
        }

        await store.send(.queryChanged("xyzzy")) {
            $0.query = "xyzzy"
            $0.isSearching = true
        }
        await clock.advance(by: .milliseconds(500))
        await store.receive(\.searchResponse.success) {
            $0.isSearching = false
            $0.showEmptyLabel = true
        }
    }

    @Test func resultTapEmitsShowDetails() async {
        let clock = TestClock()
        let store = TestStore(initialState: SearchFeature.State()) {
            SearchFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.movieClient.searchMovies = { _, _ in
                .mock(results: [.mockWith(id: 42)], totalPages: 1)
            }
        }

        await store.send(.queryChanged("test")) {
            $0.query = "test"
            $0.isSearching = true
        }
        await clock.advance(by: .milliseconds(500))
        await store.receive(\.searchResponse.success) {
            $0.isSearching = false
            $0.results = [.mockWith(id: 42)]
        }

        await store.send(.resultTapped(id: 42))
        await store.receive(\.delegate)
    }
}
