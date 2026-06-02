//
//  MovieService.swift
//

import Foundation
import NetworkService

@globalActor public actor ServiceActor: GlobalActor {
    public static let shared = ServiceActor()
}

public nonisolated struct MovieService: Sendable {
    private let apiKey = ProcessInfo.processInfo.environment["TMDB_API_KEY"] ?? ""
    private let baseURL = "https://api.themoviedb.org/3"
    private let networkClient: NetworkClient
    private let parser: MovieParser

    public init(
        networkClient: NetworkClient = URLSessionNetworkClient()
    ) {
        self.init(networkClient: networkClient, parser: MovieParser())
    }

    init(
        networkClient: NetworkClient = URLSessionNetworkClient(),
        parser: MovieParser = MovieParser()
    ) {
        self.networkClient = networkClient
        self.parser = parser        
    }

    @ServiceActor
    public func fetchPopularMovies(page: Int) async throws -> MovieResponse {
        let url = try makeURL(path: "/movie/popular", queryItems: [
            URLQueryItem(name: "page", value: "\(page)")
        ])
        let data = try await networkClient.data(from: url)
        return try parser.parseMovieResponse(from: data)
    }

    @ServiceActor
    public func searchMovies(query: String, page: Int = 1) async throws -> MovieResponse {
        let url = try makeURL(path: "/search/movie", queryItems: [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)")
        ])
        let data = try await networkClient.data(from: url)
        return try parser.parseMovieResponse(from: data)
    }

    private func makeURL(path: String, queryItems: [URLQueryItem] = []) throws -> URL {
        var components = URLComponents(string: baseURL + path)!
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "language", value: "en-US")
        ] + queryItems
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        return url
    }
}
