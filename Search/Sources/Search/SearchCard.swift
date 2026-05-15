//
//  SearchCard.swift
//

import Foundation
import MoviesApi
import MoviesCore

struct SearchCard: Identifiable {
    let id: Int
    let title: String
    let rating: String
    let releaseDate: String?
    let poster: URL?
}

extension SearchCard {
    init(from movie: Movie) {
        self.init(
            id: movie.id,
            title: movie.title,
            rating: movie.ratingText(),
            releaseDate: movie.releaseDate,
            poster: movie.smallPoster()
        )
    }
}

extension SearchCard {
    static var mock: Self {
        .mockWith(id: 1)
    }

    static func mockWith(id: Int) -> Self {
        Self(
            id: id,
            title: "Test movie \(id)",
            rating: "7.5",
            releaseDate: "2025-06-15",
            poster: nil
        )
    }
}
