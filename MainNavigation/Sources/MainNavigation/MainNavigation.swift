//
//  MainNavigation.swift
//

import ComposableArchitecture
import Movies
import Search
import SwiftUI

public struct MainNavigation: View {
    @Bindable private var store: StoreOf<AppFeature>

    public init(
        store: StoreOf<AppFeature> = Store(initialState: AppFeature.State()) { AppFeature() }
    ) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            MoviesView(store: store.scope(state: \.movies, action: \.movies))
                .overlay(
                    SearchOverlay(store: store.scope(state: \.search, action: \.search))
                )
        } destination: { store in
            DetailsView(store: store)
        }
    }
}
