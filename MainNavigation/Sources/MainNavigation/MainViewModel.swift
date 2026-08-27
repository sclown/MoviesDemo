//
//  MainViewModel.swift
//

import MoviesCore
import FactoryKit
import SwiftUI

@MainActor
@Observable
final class MainViewModel: MovieNavigator {
    private(set) var path = NavigationPath()

    func navigate(to movie: MovieDetails) {
        path.append(movie)
    }

    func reset(to path: NavigationPath) {
        self.path = path
    }
}

extension Container {
    @MainActor
    var mainViewModel: Factory<MainViewModel> {
        self { MainViewModel() }.singleton
    }
}
