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

    private weak var cachedMoviesViewModel: MoviesViewModel?

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
        MoviesView(viewModel: makeMoviesViewModel())
    }

    public func details(movie: MovieDetails) -> some View {
        DetailsView(movie: movie)
    }

    private func makeMoviesViewModel() -> MoviesViewModel {
        if let cached = cachedMoviesViewModel { return cached }
        let vm = MoviesViewModel(
            service: environment.movieService,
            navigation: navigation
        )
        cachedMoviesViewModel = vm
        return vm
    }
}
