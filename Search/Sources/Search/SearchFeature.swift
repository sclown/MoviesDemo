//
//  SearchFeature.swift
//

import Foundation
import MoviesApi
import MoviesCore

enum SearchAction {
    case queryChanged(String)
    case searchResponse(query: String, Result<MovieResponse, Error>)
    case resultTapped(id: Int)
}

private enum SearchCancelID: Hashable {
    case search
}

typealias SearchStore = Store<SearchState, SearchAction>

@MainActor
func searchReducer(
    service: MovieService,
    navigation: @escaping (MovieDetails) -> Void
) -> Reducer<SearchState, SearchAction> {
    { state, action in
        switch action {
        case let .queryChanged(query):
            guard query != state.searchQuery else { return .none }

            if query.isEmpty {
                state.loaded = []
                state.searchResults = []
                state.isSearching = false
                state.searchQuery = ""
                state.showEmptyLabel = false
                return .cancel(id: SearchCancelID.search)
            }

            state.isSearching = true
            state.searchQuery = query
            state.showEmptyLabel = false
            return .run(id: SearchCancelID.search) { send in
                do {
                    try await Task.sleep(for: .milliseconds(500))
                    let response = try await service.searchMovies(query: query)
                    send(.searchResponse(query: query, .success(response)))
                } catch {
                    guard !Task.isCancelled else { return }
                    send(.searchResponse(query: query, .failure(error)))
                }
            }

        case let .searchResponse(query, result):
            let movies = (try? result.get())?.results ?? []
            state.loaded = movies
            state.searchResults = movies.map { SearchCard(from: $0) }
            state.isSearching = false
            state.searchQuery = query
            state.showEmptyLabel = movies.isEmpty && !query.isEmpty
            return .none

        case let .resultTapped(id):
            if let movie = state.loaded.first(where: { $0.id == id }) {
                navigation(movie.details())
            }
            return .none
        }
    }
}
