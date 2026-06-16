import Testing
import Foundation
import SwiftUI

import MoviesCore
@testable import MainNavigation

@MainActor
private func makeStore() -> NavigationStore {
    NavigationStore(initialState: NavigationState(), reducer: navigationReducer())
}

@MainActor
struct NavigationStoreTests {
    @Test func initialPathIsEmpty() {
        let store = makeStore()
        #expect(store.state.path.isEmpty)
    }

    @Test func navigateAppendsToPath() {
        let store = makeStore()

        store.send(.navigate(.mock))

        #expect(store.state.path.count == 1)
    }

    @Test func pathChangedReplacesPath() {
        let store = makeStore()

        store.send(.navigate(.mockWith(id: 1)))
        store.send(.pathChanged(NavigationPath()))

        #expect(store.state.path.isEmpty)
    }
}
