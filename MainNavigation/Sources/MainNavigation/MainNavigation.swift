//
//  MainNavigation.swift
//

import MoviesApi
import MoviesCore
import Movies
import Search
import SwiftUI

public struct MainNavigation: View {
    private let viewModel: MainViewModel
    private let moviesModule: MoviesModule
    private let searchModule: SearchModule
    private let appEnvironment: AppEnvironment

    public init() {
        let viewModel = MainViewModel()
        self.viewModel = viewModel
        appEnvironment = AppEnvironment(
            movieService: MovieService(),
            onShowDetails: { [viewModel] movie in
                viewModel.navigate(to: movie)
            }
        )
        moviesModule = MoviesModule(appEnvironment)
            .withNavigation { [viewModel] in
                viewModel.navigate(to: $0)
            }
        searchModule = SearchModule(appEnvironment)
            .withNavigation { [viewModel] in
                viewModel.navigate(to: $0)
            }
    }

    public var body: some View {
        NavigationStack(
            path: Binding(
                get: { viewModel.path },
                set: { viewModel.reset(to: $0) }
            )
        ) {
            moviesModule.movies()
            .overlay(searchModule.overlay())
            .navigationDestination(for: MovieDetails.self) { movie in
                moviesModule.details(movie: movie)
            }
        }
    }
}
