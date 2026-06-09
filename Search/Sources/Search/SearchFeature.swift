//
//  SearchFeature.swift
//

import ComposableArchitecture
import Foundation
import MoviesApi
import MoviesCore

@Reducer
public struct SearchFeature {
    @ObservableState
    public struct State: Equatable {
        var query = ""
        var results: [Movie] = []
        var isSearching = false
        var showEmptyLabel = false

        public init() {}
    }

    public enum Action {
        case queryChanged(String)
        case searchResponse(Result<MovieResponse, Error>)
        case resultTapped(id: Int)
        case delegate(Delegate)

        public enum Delegate {
            case showDetails(MovieDetails)
        }
    }

    @Dependency(\.movieClient) var movieClient
    @Dependency(\.continuousClock) var clock

    private enum CancelID { case search }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .queryChanged(query):
                guard query != state.query else { return .none }
                state.query = query

                guard !query.isEmpty else {
                    state.results = []
                    state.isSearching = false
                    state.showEmptyLabel = false
                    return .cancel(id: CancelID.search)
                }

                state.isSearching = true
                state.showEmptyLabel = false
                return .run { [movieClient, clock] send in
                    // Debounce: each keystroke cancels the in-flight search and
                    // waits 500ms before hitting the network.
                    try await clock.sleep(for: .milliseconds(500))
                    do {
                        let response = try await movieClient.searchMovies(query: query, page: 1)
                        await send(.searchResponse(.success(response)))
                    } catch is CancellationError {
                    } catch {
                        await send(.searchResponse(.failure(error)))
                    }
                }
                .cancellable(id: CancelID.search, cancelInFlight: true)

            case let .searchResponse(.success(response)):
                state.isSearching = false
                state.results = response.results
                state.showEmptyLabel = response.results.isEmpty && !state.query.isEmpty
                return .none

            case .searchResponse(.failure):
                state.isSearching = false
                state.results = []
                state.showEmptyLabel = !state.query.isEmpty
                return .none

            case let .resultTapped(id):
                guard let movie = state.results.first(where: { $0.id == id }) else { return .none }
                return .send(.delegate(.showDetails(movie.details())))

            case .delegate:
                return .none
            }
        }
    }
}
