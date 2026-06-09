//
//  MoviesFeature.swift
//

import ComposableArchitecture
import Foundation
import MoviesApi
import MoviesCore

@Reducer
public struct MoviesFeature {
    @ObservableState
    public struct State: Equatable {
        var movies: [Movie] = []
        var isLoading = true
        var isLoadingMore = false
        var errorMessage: String?
        var hasLoaded = false
        var currentPage = 1
        var totalPages = 1

        public init() {}
    }

    public enum Action {
        case onAppear
        case moviesResponse(Result<MovieResponse, Error>)
        case movieAppeared(id: Int)
        case loadMoreResponse(Result<MovieResponse, Error>)
        case movieTapped(id: Int)
        case delegate(Delegate)

        public enum Delegate {
            case showDetails(MovieDetails)
        }
    }

    @Dependency(\.movieClient) var movieClient

    private enum CancelID { case load, loadMore }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard !state.hasLoaded else { return .none }
                state.isLoading = true
                state.currentPage = 1
                return .run { [movieClient] send in
                    do {
                        let response = try await movieClient.fetchPopularMovies(page: 1)
                        await send(.moviesResponse(.success(response)))
                    } catch is CancellationError {
                    } catch {
                        await send(.moviesResponse(.failure(error)))
                    }
                }
                .cancellable(id: CancelID.load, cancelInFlight: true)

            case let .moviesResponse(.success(response)):
                state.isLoading = false
                state.movies = response.results
                state.totalPages = response.totalPages
                state.hasLoaded = true
                state.errorMessage = nil
                return .none

            case let .moviesResponse(.failure(error)):
                state.isLoading = false
                state.hasLoaded = false
                state.movies = []
                state.errorMessage = error.localizedDescription
                return .none

            case let .movieAppeared(id):
                guard state.currentPage < state.totalPages,
                      id == state.movies.last?.id else { return .none }
                state.isLoadingMore = true
                let nextPage = state.currentPage + 1
                return .run { [movieClient] send in
                    do {
                        let response = try await movieClient.fetchPopularMovies(page: nextPage)
                        await send(.loadMoreResponse(.success(response)))
                    } catch is CancellationError {
                    } catch {
                        await send(.loadMoreResponse(.failure(error)))
                    }
                }
                .cancellable(id: CancelID.loadMore, cancelInFlight: true)

            case let .loadMoreResponse(.success(response)):
                state.isLoadingMore = false
                let existingIDs = Set(state.movies.map(\.id))
                state.movies += response.results.filter { !existingIDs.contains($0.id) }
                state.totalPages = response.totalPages
                state.currentPage += 1
                return .none

            case .loadMoreResponse(.failure):
                state.isLoadingMore = false
                return .none

            case let .movieTapped(id):
                guard let movie = state.movies.first(where: { $0.id == id }) else { return .none }
                return .send(.delegate(.showDetails(movie.details())))

            case .delegate:
                return .none
            }
        }
    }
}
