//
//  MoviesModule.swift
//

import MoviesApi
import MoviesCore
import SwiftUI

public protocol MoviesEnvironment {
    var movieService: MovieService { get }
}

@MainActor
public final class MoviesModule {
    private let environment: MoviesEnvironment
    private var navigation: (MovieDetails) -> Void = { _ in }

    private weak var cachedStore: MoviesStore?

    public init(_ environment: MoviesEnvironment) {
        self.environment = environment
    }

    public func withNavigation(
        handler: @escaping (MovieDetails) -> Void
    ) -> Self {
        navigation = handler
        return self
    }

    public func movies() -> some View {
        MoviesView(store: makeStore())
    }

    public func details(movie: MovieDetails) -> some View {
        DetailsView(movie: movie)
    }

    private func makeStore() -> MoviesStore {
        if let cached = cachedStore { return cached }
        let store = MoviesStore(
            initialState: .empty,
            reducer: moviesReducer(
                service: environment.movieService,
                navigation: navigation
            )
        )
        cachedStore = store
        return store
    }
}
