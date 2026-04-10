//
//  AppEnvironment.swift
//

import MoviesApi
import Features

struct AppEnvironment {
    let movieService: MovieService
    let onNavigation: (MovieDetails) -> Void
    
    @MainActor
    init(movieService: MovieService, onNavigation: @escaping (MovieDetails) -> Void) {
        self.movieService = movieService
        self.onNavigation = onNavigation
    }
}

extension AppEnvironment:  FeaturesEnvironment {}
