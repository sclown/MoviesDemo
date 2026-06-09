//
//  Mocks.swift
//

import MoviesApi

public extension Movie {
    static var mock: Movie { mockWith(id: 1) }

    static func mockWith(id: Int) -> Movie {
        Movie(
            id: id,
            title: "Test Movie \(id)",
            overview: "A test movie",
            posterPath: "/test.jpg",
            releaseDate: "2025-01-01",
            voteAverage: 7.5
        )
    }
}

public extension MovieResponse {
    static func mock(results: [Movie], totalPages: Int = 5) -> MovieResponse {
        MovieResponse(results: results, totalPages: totalPages)
    }

    static func mock(ids: Range<Int> = 1..<3, totalPages: Int = 5) -> MovieResponse {
        MovieResponse(results: ids.map(Movie.mockWith(id:)), totalPages: totalPages)
    }
}
