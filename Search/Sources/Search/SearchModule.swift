//
//  SearchModule.swift
//

import MoviesApi
import MoviesCore
import FactoryKit
import SwiftUI

extension Container {
    @MainActor
    var searchViewModel: Factory<any SearchViewModeling> {
        self {
            let navigator = self.movieNavigator()
            return SearchViewModel(
                service: self.movieService(),
                navigation: { [weak navigator] movie in navigator?.navigate(to: movie) }
            )
        }
        .cached
    }
}
