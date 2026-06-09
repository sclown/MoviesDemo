import ComposableArchitecture
import Testing
import MoviesApi
import MoviesApiMocks
import MoviesCore
import NetworkService
@testable import Movies

@MainActor
struct MoviesFeatureTests {
    @Test func loadSetsMovies() async {
        let store = TestStore(initialState: MoviesFeature.State()) {
            MoviesFeature()
        } withDependencies: {
            $0.movieClient.fetchPopularMovies = { _ in .mock(ids: 1..<3, totalPages: 5) }
        }

        await store.send(.onAppear)
        await store.receive(\.moviesResponse.success) {
            $0.isLoading = false
            $0.movies = (1..<3).map(Movie.mockWith(id:))
            $0.totalPages = 5
            $0.hasLoaded = true
        }
    }

    @Test func loadSetsErrorOnFailure() async {
        let store = TestStore(initialState: MoviesFeature.State()) {
            MoviesFeature()
        } withDependencies: {
            $0.movieClient.fetchPopularMovies = { _ in throw NetworkError.noConnection }
        }

        await store.send(.onAppear)
        await store.receive(\.moviesResponse.failure) {
            $0.isLoading = false
            $0.errorMessage = NetworkError.noConnection.localizedDescription
        }
    }

    @Test func loadMoreAppendsAndDedupes() async {
        let store = TestStore(initialState: MoviesFeature.State()) {
            MoviesFeature()
        } withDependencies: {
            $0.movieClient.fetchPopularMovies = { page in
                page == 1 ? .mock(ids: 1..<3, totalPages: 5) : .mock(ids: 2..<5, totalPages: 5)
            }
        }

        await store.send(.onAppear)
        await store.receive(\.moviesResponse.success) {
            $0.isLoading = false
            $0.movies = (1..<3).map(Movie.mockWith(id:))
            $0.totalPages = 5
            $0.hasLoaded = true
        }

        await store.send(.movieAppeared(id: 2)) {
            $0.isLoadingMore = true
        }
        await store.receive(\.loadMoreResponse.success) {
            // page 2 returns ids 2,3,4 — id 2 is deduped.
            $0.isLoadingMore = false
            $0.movies = (1..<5).map(Movie.mockWith(id:))
            $0.currentPage = 2
        }
    }

    @Test func loadMoreIgnoresNonLastMovie() async {
        let store = TestStore(initialState: MoviesFeature.State()) {
            MoviesFeature()
        } withDependencies: {
            $0.movieClient.fetchPopularMovies = { _ in .mock(ids: 1..<3, totalPages: 5) }
        }

        await store.send(.onAppear)
        await store.receive(\.moviesResponse.success) {
            $0.isLoading = false
            $0.movies = (1..<3).map(Movie.mockWith(id:))
            $0.totalPages = 5
            $0.hasLoaded = true
        }

        // id 1 is not the last loaded movie — no paging effect, no state change.
        await store.send(.movieAppeared(id: 1))
    }

    @Test func movieTappedEmitsShowDetails() async {
        let store = TestStore(initialState: MoviesFeature.State()) {
            MoviesFeature()
        } withDependencies: {
            $0.movieClient.fetchPopularMovies = { _ in .mock(ids: 1..<2, totalPages: 1) }
        }

        await store.send(.onAppear)
        await store.receive(\.moviesResponse.success) {
            $0.isLoading = false
            $0.movies = [.mockWith(id: 1)]
            $0.totalPages = 1
            $0.hasLoaded = true
        }

        await store.send(.movieTapped(id: 1))
        await store.receive(\.delegate)
    }

    @Test func movieTappedIgnoresUnknownId() async {
        let store = TestStore(initialState: MoviesFeature.State()) {
            MoviesFeature()
        } withDependencies: {
            $0.movieClient.fetchPopularMovies = { _ in .mock(ids: 1..<3, totalPages: 1) }
        }

        await store.send(.onAppear)
        await store.receive(\.moviesResponse.success) {
            $0.isLoading = false
            $0.movies = (1..<3).map(Movie.mockWith(id:))
            $0.totalPages = 1
            $0.hasLoaded = true
        }

        // Unknown id — no delegate effect.
        await store.send(.movieTapped(id: 999))
    }
}
