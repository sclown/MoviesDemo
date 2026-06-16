//
//  SearchState.swift
//

import Foundation
import MoviesApi

struct SearchState {
    // View-facing state.
    var searchResults: [SearchCard]
    var isSearching: Bool
    var searchQuery: String
    var showEmptyLabel: Bool

    // Domain bookkeeping, owned by the reducer.
    var loaded: [Movie] = []
}

extension SearchState {
    static var empty: Self {
        Self(searchResults: [], isSearching: false, searchQuery: "", showEmptyLabel: false)
    }

    static var searching: Self {
        Self(searchResults: [], isSearching: true, searchQuery: "Batman", showEmptyLabel: false)
    }

    static var noResults: Self {
        Self(searchResults: [], isSearching: false, searchQuery: "xyzzy", showEmptyLabel: true)
    }

    static var results3: Self {
        Self(
            searchResults: [
                .mockWith(id: 1),
                .mockWith(id: 2),
                .mockWith(id: 3)
            ],
            isSearching: false,
            searchQuery: "Movie",
            showEmptyLabel: false
        )
    }
}
