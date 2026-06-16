//
//  MainNavigation.swift
//

import MoviesApi
import MoviesCore
import Movies
import Search
import SwiftUI

public struct MainNavigation: View {
    private let store: NavigationStore
    private let moviesModule: MoviesModule
    private let searchModule: SearchModule
    private let appEnvironment: AppEnvironment

    public init() {
        let store = NavigationStore(
            initialState: NavigationState(),
            reducer: navigationReducer()
        )
        self.store = store
        appEnvironment = AppEnvironment(
            movieService: MovieService(),
            onShowDetails: { [store] movie in
                store.send(.navigate(movie))
            }
        )
        moviesModule = MoviesModule(appEnvironment)
            .withNavigation { [store] in
                store.send(.navigate($0))
            }
        searchModule = SearchModule(appEnvironment)
            .withNavigation { [store] in
                store.send(.navigate($0))
            }
    }

    public var body: some View {
        NavigationStack(
            path: Binding(
                get: { store.state.path },
                set: { store.send(.pathChanged($0)) }
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
