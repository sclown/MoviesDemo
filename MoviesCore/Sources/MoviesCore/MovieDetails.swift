//
//  MovieDetails.swift
//

import Foundation

public struct MovieDetails: Hashable, Sendable {
    public let id: Int
    public let title: String
    public let poster: URL?
    public let rating: String
    public let releaseDate: String?
    public let overview: String

    public init(
        id: Int,
        title: String,
        poster: URL?,
        rating: String,
        releaseDate: String?,
        overview: String
    ) {
        self.id = id
        self.title = title
        self.poster = poster
        self.rating = rating
        self.releaseDate = releaseDate
        self.overview = overview
    }
}

extension MovieDetails {
    public static var mock: Self {
        mockWith(id: 1)
    }

    public static func mockWith(id: Int) -> Self {
        Self(
            id: id,
            title: "Test Movie \(id)",
            poster: nil,
            rating: "8.5",
            releaseDate: "2025-06-15",
            overview: "A great movie about testing software and building apps."
        )
    }
}
