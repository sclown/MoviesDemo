//
//  MainNavigation.swift
//

import MoviesApi
import Features
import SwiftUI

public struct MainNavigation: View {
    private let viewModel: MainViewModel
    private let features: FeaturesModule
    private let appEnvironment: AppEnvironment

    public init() {
        let viewModel = MainViewModel()
        self.viewModel = viewModel
        appEnvironment = AppEnvironment(
            movieService: MovieService(),
            onNavigation: { [weak viewModel] movie in
                viewModel?.navigate(to: movie)
            }
        )
        features = FeaturesModule(appEnvironment)
    }

    public var body: some View {
        NavigationStack(
            path: Binding(
                get: { viewModel.path },
                set: { viewModel.reset(to: $0) }
            )
        ) {
            features.movies()
                .navigationDestination(for: MovieDetails.self) { movie in
                    features.details(movie: movie)
                }
        }
    }
}
