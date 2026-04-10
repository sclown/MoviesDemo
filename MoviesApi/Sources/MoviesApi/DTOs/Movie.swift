//
//  Movie.swift
//

import Foundation

public nonisolated struct MovieResponse: Decodable, Sendable {
    public let results: [Movie]
    public let totalPages: Int
}

public nonisolated struct Movie: Decodable, Hashable, Sendable {
    public let id: Int
    public let title: String
    public let overview: String
    public let posterPath: String?
    public let releaseDate: String?
    public let voteAverage: Double
}
