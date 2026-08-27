import Testing
import Foundation
@testable import Movies
import MoviesCore
import MoviesApi
import MoviesApiMocks
import NetworkService
import NetworkServiceMocks

@MainActor
private func makeViewModel(
    data: Result<Data, Error>,
    logger: TestStateLogger<MoviesListState>,
    navigation: @escaping @MainActor (MovieDetails) -> () = { _ in }
) -> MoviesViewModel {
    let client = MockNetworkClient(result: data)
    let service = MovieService(networkClient: client)
    let vm = MoviesViewModel(service: service, navigation: navigation)
    vm.state.didChange = logger.log
    return vm
}

@MainActor
struct MoviesViewModelTests {
    @Test func loadSetsMovies() async throws {
        let logger = TestStateLogger<MoviesListState>()
        let vm = makeViewModel(data: .success(.validList()), logger: logger)

        vm.load()
        let loading = try await logger.next()
        let loaded = try await logger.next()

        #expect(loading.isLoading == true)
        #expect(loaded.isLoading == false)
        #expect(loaded.movies.count == 2)
        #expect(loaded.errorMessage == nil)
    }

    @Test func loadSetsErrorOnFailure() async throws {
        let logger = TestStateLogger<MoviesListState>()
        let vm = makeViewModel(data: .failure(NetworkError.noConnection), logger: logger)

        vm.load()
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
        let vm = MoviesViewModel(service: service)
        vm.state.didChange = logger.log

        vm.load()
        _ = try await logger.collect(count: 2)
        client.result = .success(.validList(range: 3..<5))

        let lastMovie = vm.state.value.movies.last!
        vm.loadMoreIfNeeded(currentMovieId: lastMovie.id)
        let loading = try await logger.next()
        let loaded = try await logger.next()

        #expect(loading.isLoadingMore == true)
        #expect(loaded.isLoadingMore == false)
        #expect(loaded.movies.count == 4)
    }

    @Test func loadMoreIgnoresNonLastMovie() async throws {
        let logger = TestStateLogger<MoviesListState>()
        let vm = makeViewModel(data: .success(.validList(total: 3)), logger: logger)

        vm.load()
        try await logger.collect(count: 2)

        let firstMovie = vm.state.value.movies.first!
        vm.loadMoreIfNeeded(currentMovieId: firstMovie.id)
        await #expect(throws: TestLoggerTimeout.self) {
            try await logger.collect(count: 1, timeout: .milliseconds(100))
        }
        #expect(vm.state.value.movies.count == 2)
    }

    @Test func showDetailsTriggersNavigation() async throws {
        let logger = TestStateLogger<MoviesListState>()
        var navigatedMovie: MovieDetails?
        let navigation: @MainActor (MovieDetails) -> Void = { navigatedMovie = $0 }

        let vm = makeViewModel(
            data: .success(.validList(total: 1)),
            logger: logger,
            navigation: navigation
        )

        vm.load()
        _ = try await logger.collect(count: 2)

        vm.showDetails(for: 1)

        #expect(navigatedMovie != nil)
        #expect(navigatedMovie?.id == 1)
        #expect(navigatedMovie?.title == "Test Movie 1")
    }

    @Test func showDetailsIgnoresUnknownId() async throws {
        let logger = TestStateLogger<MoviesListState>()
        var navigatedMovie: MovieDetails?
        let navigation: @MainActor (MovieDetails) -> Void = { navigatedMovie = $0 }

        let vm = makeViewModel(
            data: .success(.validList()),
            logger: logger,
            navigation: navigation
        )

        vm.load()
        _ = try await logger.collect(count: 2)

        vm.showDetails(for: 999)

        #expect(navigatedMovie == nil)
    }
}
