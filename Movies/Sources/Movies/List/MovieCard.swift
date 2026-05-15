//
//  MovieCard.swift
//

import Foundation
import MoviesApi
import MoviesCore

struct MovieCard: Identifiable {
    let id: Int
    let title: String
    let poster: URL?
}

extension MovieCard {
    init(from movie: Movie) {
        self.init(
            id: movie.id,
            title: movie.title,
            poster: movie.smallPoster()
        )
    }
}

extension MovieCard {
    static var mock: Self {
        mockWith(id: 1)
    }

    static func mockWith(id: Int) -> Self {
        Self(id: id, title: "Movie title \(id)", poster: nil)
    }
}
