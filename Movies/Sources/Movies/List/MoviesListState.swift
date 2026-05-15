//
//  MoviesListState.swift
//

import Foundation

struct MoviesListState {
    let movies: [MovieCard]
    let isLoading: Bool
    let isLoadingMore: Bool
    let errorMessage: String?
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
