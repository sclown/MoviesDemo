//
//  FeaturesModule.swift
//

import MoviesApi
import SwiftUI

public protocol FeaturesEnvironment {
    var movieService: MovieService { get }
    @MainActor var onNavigation: (MovieDetails) -> Void { get }
}

@MainActor
public final class FeaturesModule {
    private let environment: FeaturesEnvironment
    private let navigation = Navigation()

    private weak var cachedMoviesViewModel: MoviesViewModel?
    private weak var cachedSearchViewModel: SearchViewModel?

    public init(_ environment: FeaturesEnvironment) {
        self.environment = environment
        navigation.onNavigation = environment.onNavigation
    }

    public func movies() -> some View {
        MoviesView(
            viewModel: makeMoviesViewModel(),
            searchViewModel: makeSearchViewModel()
        )
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

    private func makeSearchViewModel() -> SearchViewModel {
        if let cached = cachedSearchViewModel { return cached }
        let vm = SearchViewModel(
            service: environment.movieService,
            navigation: navigation
        )
        cachedSearchViewModel = vm
        return vm
    }
}

typealias StateLogger<State> = @Sendable (State) -> Void
