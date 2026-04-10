//
//  MovieDetails.swift
//

import Foundation

public struct MovieDetails: Hashable {
    let id: Int
    let title: String
    let poster: URL?
    let rating: String
    let releaseDate: String?
    let overview: String
}

extension MovieDetails {
    static var mock: Self {
        mockWith(id: 1)
    }

    static func mockWith(id: Int) -> Self {
        Self(
            id: id,
            title: "Test Movie \(id)",
            poster: nil,
            rating: "8.5",
            releaseDate: "2025-06-15",
            overview: "A great movie about testing software and building apps.",
        )
    }
}
