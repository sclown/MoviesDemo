//
//  MoviesView.swift
//

import SwiftUI

struct MoviesView: View {
    let viewModel: MoviesViewModeling
    let searchViewModel: SearchViewModeling
    private var state: MoviesListState { viewModel.state.value }

    var body: some View {
        ZStack {
            if state.isLoading {
                LoadingView()
            } else if let error = state.errorMessage {
                ErrorView(message: error) {
                    viewModel.load()
                }
            } else {
                movieGrid(state: state)
            }

            SearchOverlay(viewModel: searchViewModel)
        }
        .navigationTitle(Text("Popular Movies", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.load()
        }
    }

    private func movieGrid(state: MoviesListState) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(state.movies) { movie in
                    Button {
                        viewModel.showDetails(for: movie.id)
                    } label: {
                        MovieCell(movie: movie)
                    }
                    .onAppear {
                        viewModel.loadMoreIfNeeded(currentMovieId: movie.id)
                    }
                }
            }
            .padding(12)
            .padding(.bottom, 60)
        }
    }

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]
}

struct MoviesView_Previews: PreviewProvider {
    static var loading: some View {
        NavigationStack {
            MoviesView(viewModel: PreviewMoviesViewModel(state: ObservableState(.empty)), searchViewModel: PreviewSearchViewModel())
        }
        .preferredColorScheme(.dark)
    }

    static var error: some View {
        NavigationStack {
            MoviesView(viewModel: PreviewMoviesViewModel(state: ObservableState(.error)), searchViewModel: PreviewSearchViewModel())
        }
        .preferredColorScheme(.dark)
    }

    static var movies3: some View {
        NavigationStack {
            MoviesView(viewModel: PreviewMoviesViewModel(state: ObservableState(.movies3)), searchViewModel: PreviewSearchViewModel())
        }
        .preferredColorScheme(.dark)
    }

    static var movies8: some View {
        NavigationStack {
            MoviesView(viewModel: PreviewMoviesViewModel(state: ObservableState(.movies8)), searchViewModel: PreviewSearchViewModel())
        }
        .preferredColorScheme(.dark)
    }

    static var previews: some View {
        movies8.previewDisplayName("8 Movies")
        movies3.previewDisplayName("3 Movies")
        loading.previewDisplayName("Loading")
        error.previewDisplayName("Error")
    }

    struct PreviewMoviesViewModel: MoviesViewModeling {
        let state: ObservableState<MoviesListState>
        func load() {}
        func loadMoreIfNeeded(currentMovieId: Int) {}
        func showDetails(for movieId: Int) {}
    }

    struct PreviewSearchViewModel: SearchViewModeling {
        let state = ObservableState(SearchState.empty)
        func updateSearchQuery(_ query: String) {}
        func showDetails(for movieId: Int) {}
    }
}
