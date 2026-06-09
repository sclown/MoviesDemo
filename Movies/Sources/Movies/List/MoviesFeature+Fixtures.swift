//
//  MoviesFeature+Fixtures.swift
//

import Foundation
import MoviesApi

extension MoviesFeature.State {
    /// All fixtures set `hasLoaded = true` so `.onAppear` short-circuits and
    /// previews/snapshots never trigger a live network fetch.
    static var loading: Self {
        var state = Self()
        state.isLoading = true
        state.hasLoaded = true
        return state
    }

    static var error: Self {
        var state = Self()
        state.isLoading = false
        state.hasLoaded = true
        state.errorMessage = "Some error message"
        return state
    }

    static var movies3: Self {
        loaded(ids: 1...3)
    }

    static var movies8: Self {
        loaded(ids: 1...8)
    }

    private static func loaded(ids: ClosedRange<Int>) -> Self {
        var state = Self()
        state.isLoading = false
        state.hasLoaded = true
        state.movies = ids.map(Movie.preview(id:))
        return state
    }
}

private extension Movie {
    /// Mirrors the previous `MovieCard.mockWith` fixtures: title "Movie title N",
    /// no poster — so rendered cards match.
    static func preview(id: Int) -> Movie {
        Movie(
            id: id,
            title: "Movie title \(id)",
            overview: "A great movie about testing software and building apps.",
            posterPath: nil,
            releaseDate: "2025-06-15",
            voteAverage: 8.5
        )
    }
}
