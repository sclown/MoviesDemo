//
//  SearchOverlay.swift
//

import ComposableArchitecture
import SwiftUI
import MoviesCore

public struct SearchOverlay: View {
    let store: StoreOf<SearchFeature>
    @FocusState private var isSearchFocused: Bool

    public init(store: StoreOf<SearchFeature>) {
        self.store = store
    }

    private var cards: [SearchCard] {
        store.results.map(SearchCard.init(from:))
    }

    public var body: some View {
        ZStack {
            if isActive {
                dimming
            }

            VStack {
                Spacer()
                if isActive {
                    searchResults
                }
                SearchBar(
                    text: Binding(
                        get: { store.query },
                        set: { store.send(.queryChanged($0)) }
                    ),
                    isFocused: $isSearchFocused
                ) {
                    store.send(.queryChanged(""))
                    isSearchFocused = false
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
        }
    }

    @ViewBuilder
    private var dimming: some View {
        Color.black.opacity(store.results.isEmpty ? 0.8 : 1)
            .ignoresSafeArea()
            .allowsHitTesting(true)
            .onTapGesture {
                isSearchFocused = false
            }
    }

    @ViewBuilder
    private var searchResults: some View {
        if store.showEmptyLabel {
            EmptySearchResultsView(query: store.query)
        } else if !store.query.isEmpty {
            resultsList
                .ignoresSafeArea(edges: .top)
                .overlay(alignment: .bottom) {
                    if store.isSearching {
                        ProgressView().padding(8)
                    }
                }
        }
    }

    @ViewBuilder
    private var resultsList: some View {
        VStack {
            List(cards) { movie in
                Button {
                    store.send(.resultTapped(id: movie.id))
                    isSearchFocused = false
                } label: {
                    SearchResultRow(movie: movie)
                }
            }
            .listStyle(.plain)
            .accessibilityIdentifier("searchResults")
            .scrollDismissesKeyboard(.interactively)
        }
    }

    private var isActive: Bool {
        isSearchFocused || !store.query.isEmpty
    }
}

struct SearchOverlay_Previews: PreviewProvider {
    private static func view(_ state: SearchFeature.State) -> some View {
        ZStack {
            Color.black.ignoresSafeArea()
            SearchOverlay(store: Store(initialState: state) { SearchFeature() })
        }
        .preferredColorScheme(.dark)
    }

    static var previews: some View {
        view(.searching).previewDisplayName("Loading")
        view(.noResults).previewDisplayName("Empty")
        view(.results3).previewDisplayName("3 Results")
    }
}
