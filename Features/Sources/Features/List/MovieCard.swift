//
//  MovieCard.swift
//

import Foundation

struct MovieCard: Identifiable {
    let id: Int
    let title: String
    let poster: URL?
}

extension MovieCard {
    static var mock: Self {
        mockWith(id: 1)
    }

    static func mockWith(id: Int) -> Self {
        Self(id: id, title: "Movie title \(id)", poster: nil)
    }
}
