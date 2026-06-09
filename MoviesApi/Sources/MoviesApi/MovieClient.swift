//
//  MovieClient.swift
//

import ComposableArchitecture

/// TCA dependency client wrapping `MovieService`, so reducers can fetch movies
/// via `@Dependency(\.movieClient)` and tests can substitute endpoints.
@DependencyClient
public struct MovieClient: Sendable {
    public var fetchPopularMovies: @Sendable (_ page: Int) async throws -> MovieResponse
    public var searchMovies: @Sendable (_ query: String, _ page: Int) async throws -> MovieResponse
}

extension MovieClient: DependencyKey {
    public static let liveValue = MovieClient(
        fetchPopularMovies: { page in
            try await MovieService().fetchPopularMovies(page: page)
        },
        searchMovies: { query, page in
            try await MovieService().searchMovies(query: query, page: page)
        }
    )
}

extension DependencyValues {
    public var movieClient: MovieClient {
        get { self[MovieClient.self] }
        set { self[MovieClient.self] = newValue }
    }
}
