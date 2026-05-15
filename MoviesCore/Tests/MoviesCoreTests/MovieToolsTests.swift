import Testing
import Foundation
import MoviesApi
@testable import MoviesCore

struct MovieToolsTests {
    private func makeMovie(posterPath: String? = "/abc.jpg", vote: Double = 7.45) throws -> Movie {
        let posterField: String = posterPath.map { "\"\($0)\"" } ?? "null"
        let json = """
        {"id": 1, "title": "Test", "overview": "Overview", "poster_path": \(posterField), "release_date": "2025-01-02", "vote_average": \(vote)}
        """
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Movie.self, from: Data(json.utf8))
    }

    @Test func ratingTextIsOneDecimal() throws {
        let movie = try makeMovie(vote: 7.456)
        #expect(movie.ratingText() == "7.5")
    }

    @Test func postersReturnNilWhenPathMissing() throws {
        let movie = try makeMovie(posterPath: nil)
        #expect(movie.fullPoster() == nil)
        #expect(movie.smallPoster() == nil)
    }

    @Test func detailsCopiesFields() throws {
        let movie = try makeMovie()
        let details = movie.details()
        #expect(details.id == movie.id)
        #expect(details.title == movie.title)
        #expect(details.releaseDate == movie.releaseDate)
        #expect(details.overview == movie.overview)
    }
}
