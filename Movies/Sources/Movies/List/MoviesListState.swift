//
//  MoviesListState.swift
//

import Foundation
import MoviesApi

struct MoviesListState {
    // View-facing state.
    var movies: [MovieCard]
    var isLoading: Bool
    var isLoadingMore: Bool
    var errorMessage: String?

    // Domain bookkeeping, owned by the reducer.
    var loaded: [Movie] = []
    var hasLoaded = false
    var currentPage = 1
    var totalPages = 1
}

extension MoviesListState {
    static var empty: Self {
        Self(
            movies: [],
            isLoading: true,
            isLoadingMore: false,
            errorMessage: nil
        )
    }
}

extension MoviesListState {
    static var error: Self {
        Self(movies: [], isLoading: false, isLoadingMore: false, errorMessage: "Some error message")
    }

    static var movies3: Self {
        Self(
            movies: [
                .mockWith(id: 1),
                .mockWith(id: 2),
                .mockWith(id: 3)
            ],
            isLoading: false,
            isLoadingMore: false,
            errorMessage: nil
        )
    }

    static var movies8: Self {
        Self(
            movies: [
                .mockWith(id: 1),
                .mockWith(id: 2),
                .mockWith(id: 3),
                .mockWith(id: 4),
                .mockWith(id: 5),
                .mockWith(id: 6),
                .mockWith(id: 7),
                .mockWith(id: 8)
            ],
            isLoading: false,
            isLoadingMore: false,
            errorMessage: nil
        )
    }
}
