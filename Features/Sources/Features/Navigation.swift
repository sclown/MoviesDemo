//
//  Navigation.swift
//

import SwiftUI

final class Navigation {
    var onNavigation: ((MovieDetails) -> Void)?

    func showDetails(for movie: MovieDetails) {
        onNavigation?(movie)
    }
}
