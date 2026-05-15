//
//  MovieTools.swift
//

import Foundation
import MoviesApi

extension Movie {
    public func fullPoster() -> URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")
    }

    public func smallPoster() -> URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    public func ratingText() -> String {
        String(format: "%.1f", voteAverage)
    }

    public func details() -> MovieDetails {
        MovieDetails(
            id: id,
            title: title,
            poster: fullPoster(),
            rating: ratingText(),
            releaseDate: releaseDate,
            overview: overview
        )
    }
}
