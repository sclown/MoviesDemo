//
//  NavigationFeature.swift
//

import MoviesCore
import SwiftUI

struct NavigationState {
    var path = NavigationPath()
}

enum NavigationAction {
    case navigate(MovieDetails)
    case pathChanged(NavigationPath)
}

typealias NavigationStore = Store<NavigationState, NavigationAction>

@MainActor
func navigationReducer() -> Reducer<NavigationState, NavigationAction> {
    { state, action in
        switch action {
        case let .navigate(movie):
            state.path.append(movie)
            return .none
        case let .pathChanged(path):
            state.path = path
            return .none
        }
    }
}
