//
//  Movie.swift
//

import Foundation

public nonisolated struct MovieResponse: Decodable, Sendable {
    public let results: [Movie]
    public let totalPages: Int

    public init(results: [Movie], totalPages: Int) {
        self.results = results
        self.totalPages = totalPages
    }
}

public nonisolated struct Movie: Decodable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String?
    public let releaseDate: String?
    public let voteAverage: Double

    public init(
        id: Int,
        title: String,
        overview: String,
        posterPath: String?,
        releaseDate: String?,
        voteAverage: Double
    ) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
    }
}
