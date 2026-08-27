//
//  MoviesView.swift
//

import FactoryKit
import MoviesCore
import SwiftUI

public struct MoviesView: View {
    let viewModel: MoviesViewModeling = Container.shared.moviesViewModel()
    private var state: MoviesListState { viewModel.state.value }
    
    public init() { }

    public var body: some View {
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    
    static func view(with state: MoviesListState) -> some View {
        Container.shared.moviesViewModel.register {
            PreviewMoviesViewModel(state: ObservableState(state))
        }
        return MoviesView()
    }
    
    static var loading: some View {
        NavigationStack {
            view(with: .empty)
        }
        .preferredColorScheme(.dark)
    }

    static var error: some View {
        NavigationStack {
            view(with: .error)
        }
        .preferredColorScheme(.dark)
    }

    static var movies3: some View {
        NavigationStack {
            view(with: .movies3)
        }
        .preferredColorScheme(.dark)
    }

    static var movies8: some View {
        NavigationStack {
            view(with: .movies8)
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
}
