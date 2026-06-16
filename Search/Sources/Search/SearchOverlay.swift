//
//  SearchOverlay.swift
//

import SwiftUI
import MoviesCore

struct SearchOverlay: View {
    let store: SearchStore
    @FocusState private var isSearchFocused: Bool

    private var state: SearchState { store.state }

    var body: some View {
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
                        get: { state.searchQuery },
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
        Color.black.opacity(state.searchResults.isEmpty ? 0.8 : 1)
            .ignoresSafeArea()
            .allowsHitTesting(true)
            .onTapGesture {
                isSearchFocused = false
            }
    }

    @ViewBuilder
    private var searchResults: some View {
        if state.showEmptyLabel {
            EmptySearchResultsView(query: state.searchQuery)
        } else if !state.searchQuery.isEmpty {
            resultsList
                .ignoresSafeArea(edges: .top)
                .overlay(alignment: .bottom) {
                    if state.isSearching {
                        ProgressView().padding(8)
                    }
                }
        }
    }

    @ViewBuilder
    private var resultsList: some View {
        VStack {
            List(state.searchResults) { movie in
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
        isSearchFocused || !state.searchQuery.isEmpty
    }
}

struct SearchOverlay_Previews: PreviewProvider {
    private static func previewStore(_ state: SearchState) -> SearchStore {
        Store(initialState: state) { _, _ in .none }
    }

    struct Wrapper: View {
        let store: SearchStore

        var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()
                SearchOverlay(store: store)
            }
        }
    }

    static var searching: some View {
        Wrapper(store: previewStore(.searching))
            .preferredColorScheme(.dark)
    }

    static var empty: some View {
        Wrapper(store: previewStore(.noResults))
            .preferredColorScheme(.dark)
    }

    static var results3: some View {
        Wrapper(store: previewStore(.results3))
            .preferredColorScheme(.dark)
    }

    static var previews: some View {
        searching.previewDisplayName("Loading")
        empty.previewDisplayName("Empty")
        results3.previewDisplayName("3 Results")
    }
}
