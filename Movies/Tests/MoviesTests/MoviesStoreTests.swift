import Testing
import Foundation
@testable import Movies
import MoviesCore
import MoviesApi
import MoviesApiMocks
import NetworkService
import NetworkServiceMocks

@MainActor
private func makeStore(
    data: Result<Data, Error>,
    logger: TestStateLogger<MoviesListState>,
    navigation: @escaping (MovieDetails) -> () = { _ in }
) -> MoviesStore {
    let client = MockNetworkClient(result: data)
    let service = MovieService(networkClient: client)
    let store = MoviesStore(
        initialState: .empty,
        reducer: moviesReducer(service: service, navigation: navigation)
    )
    store.didChange = logger.log
    return store
}

@MainActor
struct MoviesStoreTests {
    @Test func loadSetsMovies() async throws {
        let logger = TestStateLogger<MoviesListState>()
        let store = makeStore(data: .success(.validList()), logger: logger)

        store.send(.onAppear)
        let loading = try await logger.next()
        let loaded = try await logger.next()

        #expect(loading.isLoading == true)
        #expect(loaded.isLoading == false)
        #expect(loaded.movies.count == 2)
        #expect(loaded.errorMessage == nil)
    }

    @Test func loadSetsErrorOnFailure() async throws {
        let logger = TestStateLogger<MoviesListState>()
        let store = makeStore(data: .failure(NetworkError.noConnection), logger: logger)

        store.send(.onAppear)
        let loading = try await logger.next()
        let loaded = try await logger.next()

        #expect(loading.isLoading == true)
        #expect(loaded.isLoading == false)
        #expect(loaded.movies.isEmpty)
        #expect(loaded.errorMessage != nil)
    }

    @Test func loadMoreAppendsMovies() async throws {
        let logger = TestStateLogger<MoviesListState>()
        let client = MockNetworkClient(result: .success(.validList(range: 1..<3)))
        let service = MovieService(networkClient: client)
        let store = MoviesStore(
            initialState: .empty,
            reducer: moviesReducer(service: service, navigation: { _ in })
        )
        store.didChange = logger.log

        store.send(.onAppear)
        _ = try await logger.collect(count: 2)
        client.result = .success(.validList(range: 3..<5))

        let lastMovie = store.state.movies.last!
        store.send(.movieAppeared(id: lastMovie.id))
        let loading = try await logger.next()
        let loaded = try await logger.next()

        #expect(loading.isLoadingMore == true)
        #expect(loaded.isLoadingMore == false)
        #expect(loaded.movies.count == 4)
    }

    @Test func loadMoreIgnoresNonLastMovie() async throws {
        let logger = TestStateLogger<MoviesListState>()
        let store = makeStore(data: .success(.validList(total: 3)), logger: logger)

        store.send(.onAppear)
        try await logger.collect(count: 2)

        let firstMovie = store.state.movies.first!
        store.send(.movieAppeared(id: firstMovie.id))

        #expect(store.state.movies.count == 2)
        #expect(store.state.isLoadingMore == false)
    }

    @Test func cardTapTriggersNavigation() async throws {
        let logger = TestStateLogger<MoviesListState>()
        var navigatedMovie: MovieDetails?
        let navigation: (MovieDetails) -> Void = { navigatedMovie = $0 }

        let store = makeStore(
            data: .success(.validList(total: 1)),
            logger: logger,
            navigation: navigation
        )

        store.send(.onAppear)
        _ = try await logger.collect(count: 2)

        store.send(.cardTapped(id: 1))

        #expect(navigatedMovie != nil)
        #expect(navigatedMovie?.id == 1)
        #expect(navigatedMovie?.title == "Test Movie 1")
    }

    @Test func cardTapIgnoresUnknownId() async throws {
        let logger = TestStateLogger<MoviesListState>()
        var navigatedMovie: MovieDetails?
        let navigation: (MovieDetails) -> Void = { navigatedMovie = $0 }

        let store = makeStore(
            data: .success(.validList()),
            logger: logger,
            navigation: navigation
        )

        store.send(.onAppear)
        _ = try await logger.collect(count: 2)

        store.send(.cardTapped(id: 999))

        #expect(navigatedMovie == nil)
    }
}
