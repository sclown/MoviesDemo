import Testing
import Foundation
import MoviesApiMocks

@testable import MoviesApi

struct MovieParserTests {
    let parser = MovieParser()

    @Test func parsesValidResponse() throws {
        let response = try parser.parseMovieResponse(from: .validList)

        #expect(response.results.count == 1)
        #expect(response.totalPages == 5)
        #expect(response.results[0].title == "Test Movie 1")
        #expect(response.results[0].posterPath == "/test.jpg")
        #expect(response.results[0].releaseDate == "2025-01-01")
        #expect(response.results[0].voteAverage == 7.5)
    }

    @Test func parsesResponseWithNullOptionals() throws {
        let response = try parser.parseMovieResponse(from: .lowDataList)

        #expect(response.results[0].posterPath == nil)
        #expect(response.results[0].releaseDate == nil)
    }

    @Test func throwsOnInvalidJSON() {
        let data = "not json".data(using: .utf8)!

        #expect(throws: (any Error).self) {
            try parser.parseMovieResponse(from: data)
        }
    }

    @Test func throwsOnMissingRequiredField() {
        #expect(throws: (any Error).self) {
            try parser.parseMovieResponse(from: .invalidDataList)
        }
    }
}
