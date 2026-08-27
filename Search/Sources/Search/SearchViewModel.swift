//
//  SearchViewModel.swift
//

import MoviesApi
import MoviesCore
import Foundation
import Combine

@MainActor
protocol SearchViewModeling {
    var state: ObservableState<SearchState> { get }
    func updateSearchQuery(_ query: String)
    func showDetails(for movieId: Int)
}

final class SearchViewModel: SearchViewModeling {
    let state: ObservableState<SearchState>

    private var searchResults: [Movie] = []

    private let service: any MovieServicing
    private let navigation: @MainActor (MovieDetails) -> Void
    private let logger: StateLogger<SearchState>
    private var searchTask: Task<Void, Never>?

    init(
        state: SearchState = .empty,
        service: any MovieServicing,
        navigation: @escaping @MainActor (MovieDetails) -> Void = { _ in },
        logger: @escaping StateLogger<SearchState> = { _ in }
    ) {
        self.state = ObservableState(state)
        self.service = service
        self.navigation = navigation
        self.logger = logger
    }

    deinit {
        searchTask?.cancel()
    }

    func updateSearchQuery(_ query: String) {
        guard query != state.value.searchQuery else { return }
        debounceSearch(query)
    }

    func showDetails(for movieId: Int) {
        if let movie = (searchResults.first { $0.id == movieId }) {
            navigation(movie.details())
        }
    }

    private func debounceSearch(_ query: String) {
        searchTask?.cancel()

        if query.isEmpty {
            searchResults = []
            updateState(
                searchResults: [],
                isSearching: false,
                searchQuery: "",
                showEmptyLabel: false
            )
            return
        }

        updateState(
            isSearching: true,
            searchQuery: query,
            showEmptyLabel: false
        )
        searchTask = Task { [weak self] in
            await self?.performSearch(query: query)
        }
    }

    private func performSearch(query: String) async {
        do {
            try await Task.sleep(for: .milliseconds(500))
            let response = try await service.searchMovies(query: query)
            searchResults = response.results
        } catch {
            guard !Task.isCancelled else {
                return
            }
            searchResults = []
        }

        updateState(
            searchResults: searchResults.map { SearchCard(from: $0) },
            isSearching: false,
            searchQuery: query,
            showEmptyLabel: searchResults.isEmpty && !query.isEmpty
        )
    }

    private func updateState(
        searchResults: [SearchCard]? = nil,
        isSearching: Bool? = nil,
        searchQuery: String? = nil,
        showEmptyLabel: Bool? = nil
    ) {
        let current = state.value
        let nextState = SearchState(
            searchResults: searchResults ?? current.searchResults,
            isSearching: isSearching ?? current.isSearching,
            searchQuery: searchQuery ?? current.searchQuery,
            showEmptyLabel: showEmptyLabel ?? current.showEmptyLabel
        )
        state.value = nextState
        logger(nextState)
    }
}
