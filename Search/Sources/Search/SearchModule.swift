//
//  SearchModule.swift
//

import MoviesApi
import MoviesCore
import SwiftUI

public protocol SearchEnvironment {
    var movieService: MovieService { get }
    @MainActor var onShowDetails: (MovieDetails) -> Void { get }
}

@MainActor
public final class SearchModule {
    private let environment: SearchEnvironment
    private var navigation: (MovieDetails) -> Void = { _ in }
    private weak var cachedStore: SearchStore?

    public func withNavigation(
        handler: @escaping (MovieDetails) -> Void
    ) -> Self {
        navigation = handler
        return self
    }

    public init(_ environment: SearchEnvironment) {
        self.environment = environment
    }

    public func overlay() -> some View {
        SearchOverlay(store: makeStore())
    }

    private func makeStore() -> SearchStore {
        if let cached = cachedStore { return cached }
        let store = SearchStore(
            initialState: .empty,
            reducer: searchReducer(
                service: environment.movieService,
                navigation: navigation
            )
        )
        cachedStore = store
        return store
    }
}
