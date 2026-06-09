import ComposableArchitecture
import Testing
import Movies
import Search
import MoviesCore
@testable import MainNavigation

@MainActor
struct AppFeatureTests {
    @Test func initialPathIsEmpty() {
        let state = AppFeature.State()
        #expect(state.path.isEmpty)
    }

    @Test func moviesDelegatePushesDetails() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }

        await store.send(.movies(.delegate(.showDetails(.mock)))) {
            $0.path.append(DetailsFeature.State(movie: .mock))
        }
    }

    @Test func searchDelegatePushesDetails() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }

        await store.send(.search(.delegate(.showDetails(.mockWith(id: 7))))) {
            $0.path.append(DetailsFeature.State(movie: .mockWith(id: 7)))
        }
    }
}
