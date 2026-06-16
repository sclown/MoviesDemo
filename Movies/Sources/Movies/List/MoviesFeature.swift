//
//  MoviesFeature.swift
//

import Foundation
import MoviesApi
import MoviesCore

enum MoviesAction {
    case onAppear
    case retryTapped
    case popularResponse(Result<MovieResponse, Error>)
    case movieAppeared(id: Int)
    case loadMoreResponse(Result<MovieResponse, Error>)
    case cardTapped(id: Int)
}

private enum MoviesCancelID: Hashable {
    case load
    case loadMore
}

typealias MoviesStore = Store<MoviesListState, MoviesAction>

@MainActor
func moviesReducer(
    service: MovieService,
    navigation: @escaping (MovieDetails) -> Void
) -> Reducer<MoviesListState, MoviesAction> {
    { state, action in
        switch action {
        case .onAppear:
            guard !state.hasLoaded else { return .none }
            return startLoad(&state, service: service)

        case .retryTapped:
            return startLoad(&state, service: service)

        case let .popularResponse(.success(response)):
            state.loaded = response.results
            state.movies = response.results.map { MovieCard(from: $0) }
            state.totalPages = response.totalPages
            state.currentPage = 1
            state.hasLoaded = true
            state.isLoading = false
            state.errorMessage = nil
            return .none

        case let .popularResponse(.failure(error)):
            state.loaded = []
            state.movies = []
            state.hasLoaded = false
            state.isLoading = false
            state.errorMessage = error.localizedDescription
            return .none

        case let .movieAppeared(id):
            guard state.currentPage < state.totalPages, id == state.loaded.last?.id else {
                return .none
            }
            state.isLoadingMore = true
            let nextPage = state.currentPage + 1
            return .run(id: MoviesCancelID.loadMore) { send in
                do {
                    let response = try await service.fetchPopularMovies(page: nextPage)
                    send(.loadMoreResponse(.success(response)))
                } catch {
                    guard !Task.isCancelled else { return }
                    send(.loadMoreResponse(.failure(error)))
                }
            }

        case let .loadMoreResponse(.success(response)):
            var existingIDs = Set(state.loaded.map(\.id))
            var newMovies: [Movie] = []
            for movie in response.results where existingIDs.contains(movie.id) == false {
                newMovies.append(movie)
                existingIDs.insert(movie.id)
            }
            state.loaded.append(contentsOf: newMovies)
            state.movies = state.loaded.map { MovieCard(from: $0) }
            state.totalPages = response.totalPages
            state.currentPage += 1
            state.isLoadingMore = false
            return .none

        case .loadMoreResponse(.failure):
            state.isLoadingMore = false
            return .none

        case let .cardTapped(id):
            // Navigation is the feature's output. Reading state is pure; the
            // callback itself is the side effect, invoked synchronously.
            if let movie = state.loaded.first(where: { $0.id == id }) {
                navigation(movie.details())
            }
            return .none
        }
    }
}

@MainActor
private func startLoad(
    _ state: inout MoviesListState,
    service: MovieService
) -> Effect<MoviesAction> {
    state.isLoading = true
    state.errorMessage = nil
    return .run(id: MoviesCancelID.load) { send in
        do {
            let response = try await service.fetchPopularMovies(page: 1)
            send(.popularResponse(.success(response)))
        } catch {
            guard !Task.isCancelled else { return }
            send(.popularResponse(.failure(error)))
        }
    }
}
