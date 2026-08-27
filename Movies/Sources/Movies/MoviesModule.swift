//
//  MoviesModule.swift
//

import MoviesApi
import MoviesCore
import FactoryKit
import SwiftUI

extension Container {
    @MainActor
    var moviesViewModel: Factory<any MoviesViewModeling> {
        self {
            let navigator = self.movieNavigator()
            return MoviesViewModel(
                service: self.movieService(),
                navigation: { [weak navigator] movie in navigator?.navigate(to: movie) }
            )
        }
        .cached
    }
}
