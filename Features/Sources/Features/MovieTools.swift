//
//  MovieTools.swift
//

import Foundation
import MoviesApi

extension Movie {
    func fullPoster() -> URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/original\(posterPath)")
    }

    func smallPoster() -> URL? {
        guard let posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
    }

    func ratingText() -> String {
        String(format: "%.1f", voteAverage)
    }

    func listCard() -> MovieCard {
        MovieCard(
            id: id,
            title: title,
            poster: smallPoster()
        )
    }

    func details() -> MovieDetails {
        MovieDetails(
            id: id,
            title: title,
            poster: fullPoster(),
            rating: ratingText(),
            releaseDate: releaseDate,
            overview: overview
        )
    }

    func searchInfo() -> SearchCard {
        SearchCard(
            id: id,
            title: title,
            rating: ratingText(),
            releaseDate: releaseDate,
            poster: smallPoster()
        )
    }
}
