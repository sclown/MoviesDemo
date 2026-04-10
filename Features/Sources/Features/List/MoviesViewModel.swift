//
//  MoviesViewModel.swift
//

import Foundation
import MoviesApi

@MainActor
protocol MoviesViewModeling {
    var state: ObservableState<MoviesListState> { get }
    func load()
    func loadMoreIfNeeded(currentMovieId: Int)
    func showDetails(for movieId: Int)
}

final class MoviesViewModel: MoviesViewModeling {
    let state: ObservableState<MoviesListState>

    private var movies: [Movie] = []
    private var hasLoaded = false
    private var currentPage = 1
    private var totalPages = 1

    private let service: MovieService
    private let navigation: Navigation
    private var loadTask: Task<Void, Never>?
    private var loadMoreTask: Task<Void, Never>?

    init(
        state: MoviesListState = .empty,
        service: MovieService = MovieService(),
        navigation: Navigation = Navigation(),
    ) {
        self.state = ObservableState(state)
        self.service = service
        self.navigation = navigation
    }

    deinit {
        loadTask?.cancel()
        loadMoreTask?.cancel()
    }

    func load() {
        guard !hasLoaded else { return }
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            await self?.performLoad()
        }
    }

    func loadMoreIfNeeded(currentMovieId: Int) {
        guard currentPage < totalPages, currentMovieId == movies.last?.id else { return }
        loadMoreTask?.cancel()
        loadMoreTask = Task { [weak self] in
            await self?.performLoadMore()
        }
    }

    func showDetails(for movieId: Int) {
        if let movie = (movies.first { $0.id == movieId }) {
            navigation.showDetails(for: movie.details())
        }
    }

    private func performLoad() async {
        updateState(
            movies: nil,
            isLoading: true
        )
        var errorMessage: String?
        currentPage = 1

        do {
            let response = try await service.fetchPopularMovies(page: currentPage)
            movies = response.results
            totalPages = response.totalPages
            hasLoaded = true
        } catch {
            guard !Task.isCancelled else { return }
            hasLoaded = false
            errorMessage = error.localizedDescription
        }

        updateState(
            movies: movies.map { $0.listCard() },
            isLoading: false,
            errorMessage: errorMessage
        )
    }

    private func performLoadMore() async {
        updateState(isLoadingMore: true)

        do {
            let nextPage = currentPage + 1
            let response = try await service.fetchPopularMovies(page: nextPage)
            var existingByID = Set<Int>(movies.map(\.id))
            var newMovies: [Movie] = []
            for movie in response.results where existingByID.contains(movie.id) == false {
                newMovies.append(movie)
                existingByID.insert(movie.id)
            }
            movies.append(contentsOf: newMovies)
            totalPages = response.totalPages
            currentPage = nextPage
        } catch {
            guard !Task.isCancelled else { return }
        }

        updateState(
            movies: movies.map { $0.listCard() },
            isLoadingMore: false
        )
    }

    private func updateState(
        movies: [MovieCard]? = nil,
        isLoading: Bool? = nil,
        isLoadingMore: Bool? = nil,
        errorMessage: String? = nil
    ) {
        let current = state.value
        let nextState = MoviesListState(
            movies: movies ?? current.movies,
            isLoading: isLoading ?? current.isLoading,
            isLoadingMore: isLoadingMore ?? current.isLoadingMore,
            errorMessage: errorMessage
        )
        state.value = nextState
    }
}
