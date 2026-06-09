//
//  SearchFeature+Fixtures.swift
//

import Foundation
import MoviesApi

extension SearchFeature.State {
    static var searching: Self {
        var state = Self()
        state.query = "Batman"
        state.isSearching = true
        return state
    }

    static var noResults: Self {
        var state = Self()
        state.query = "xyzzy"
        state.showEmptyLabel = true
        return state
    }

    static var results3: Self {
        var state = Self()
        state.query = "Movie"
        state.results = (1...3).map(Movie.preview(id:))
        return state
    }
}

private extension Movie {
    /// Mirrors the previous `SearchCard.mockWith` fixtures.
    static func preview(id: Int) -> Movie {
        Movie(
            id: id,
            title: "Test movie \(id)",
            overview: "A test movie",
            posterPath: nil,
            releaseDate: "2025-06-15",
            voteAverage: 7.5
        )
    }
}
