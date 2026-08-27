//
//  MainNavigation.swift
//

import MoviesCore
import Movies
import Search
import FactoryKit
import SwiftUI

@MainActor
public struct MainNavigation: View {
    @InjectedObservable(\.mainViewModel) private var viewModel

    public init() {
        Container.shared.movieNavigator.register { Container.shared.mainViewModel() }
    }

    public var body: some View {
        NavigationStack(
            path: Binding(
                get: { viewModel.path },
                set: { viewModel.reset(to: $0) }
            )
        ) {
            MoviesView()
                .overlay(SearchOverlay())
                .navigationDestination(for: MovieDetails.self) { movie in
                    DetailsView(movie: movie)
                }
        }
    }
}
