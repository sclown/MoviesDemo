//
//  AppFeature.swift
//

import ComposableArchitecture
import Movies
import Search

@Reducer
public struct AppFeature {
    @ObservableState
    public struct State: Equatable {
        var movies = MoviesFeature.State()
        var search = SearchFeature.State()
        var path = StackState<DetailsFeature.State>()

        public init() {}
    }

    public enum Action {
        case movies(MoviesFeature.Action)
        case search(SearchFeature.Action)
        case path(StackActionOf<DetailsFeature>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.movies, action: \.movies) {
            MoviesFeature()
        }
        Scope(state: \.search, action: \.search) {
            SearchFeature()
        }
        Reduce { state, action in
            switch action {
            case let .movies(.delegate(.showDetails(details))),
                 let .search(.delegate(.showDetails(details))):
                state.path.append(DetailsFeature.State(movie: details))
                return .none

            case .movies, .search, .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            DetailsFeature()
        }
    }
}
