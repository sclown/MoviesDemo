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
    private weak var cachedSearchViewModel: SearchViewModel?

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
        SearchOverlay(viewModel: makeSearchViewModel())
    }
    
    private func makeSearchViewModel() -> SearchViewModel {
        if let cached = cachedSearchViewModel { return cached }
        let vm = SearchViewModel(
            service: environment.movieService,
            navigation: navigation
        )
        cachedSearchViewModel = vm
        return vm
    }
}
