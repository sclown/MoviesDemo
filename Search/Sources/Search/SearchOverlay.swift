//
//  SearchOverlay.swift
//

import FactoryKit
import MoviesCore
import SwiftUI

public struct SearchOverlay: View {
    var viewModel: SearchViewModeling = Container.shared.searchViewModel()
    @FocusState private var isSearchFocused: Bool

    private var state: SearchState { viewModel.state.value }
    
    public init() {}

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
                        get: { state.searchQuery },
                        set: { viewModel.updateSearchQuery($0) }
                    ),
                    isFocused: $isSearchFocused
                ) {
                    viewModel.updateSearchQuery("")
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
                    viewModel.showDetails(for: movie.id)
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
    struct Wrapper: View {
        init(state: SearchState) {
            Container.shared.searchViewModel.register {
                PreviewSearchViewModel(state: ObservableState(state))
            }
        }

        var body: some View {
            ZStack {
                Color.black.ignoresSafeArea()
                SearchOverlay()
            }
        }
    }

    static var searching: some View {
        Wrapper(state: .searching)
            .preferredColorScheme(.dark)
    }

    static var empty: some View {
        Wrapper(state: .noResults)
            .preferredColorScheme(.dark)
    }

    static var results3: some View {
        Wrapper(state: .results3)
            .preferredColorScheme(.dark)
    }

    static var previews: some View {
        searching.previewDisplayName("Loading")
        empty.previewDisplayName("Empty")
        results3.previewDisplayName("3 Results")
    }

    struct PreviewSearchViewModel: SearchViewModeling {
        let state: ObservableState<SearchState>
        func updateSearchQuery(_ query: String) {}
        func showDetails(for movieId: Int) {}
    }
}
