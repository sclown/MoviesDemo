//
//  AppEnvironment.swift
//

import MoviesApi
import MoviesCore
import Movies
import Search

struct AppEnvironment {
    let movieService: MovieService
    let onShowDetails: (MovieDetails) -> Void

    @MainActor
    init(movieService: MovieService, onShowDetails: @escaping (MovieDetails) -> Void) {
        self.movieService = movieService
        self.onShowDetails = onShowDetails
    }
}

extension AppEnvironment: MoviesEnvironment {
    var onNavigation: (MovieDetails) -> Void { onShowDetails }
}

extension AppEnvironment: SearchEnvironment {}
