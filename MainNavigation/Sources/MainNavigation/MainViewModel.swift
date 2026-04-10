//
//  MainViewModel.swift
//

import Features
import SwiftUI

@Observable
final class MainViewModel {
    private(set) var path = NavigationPath()

    func navigate(to movie: MovieDetails) {
        path.append(movie)
    }

    func reset(to path: NavigationPath) {
        self.path = path
    }
}
