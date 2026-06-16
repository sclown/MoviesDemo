//
//  MoviesView.swift
//

import SwiftUI
import MoviesCore

struct MoviesView: View {
    let store: MoviesStore
    private var state: MoviesListState { store.state }

    var body: some View {
        ZStack {
            if state.isLoading {
                LoadingView()
            } else if let error = state.errorMessage {
                ErrorView(message: error) {
                    store.send(.retryTapped)
                }
            } else {
                movieGrid(state: state)
            }
        }
        .navigationTitle(Text("Popular Movies", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.onAppear)
        }
    }

    private func movieGrid(state: MoviesListState) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(state.movies) { movie in
                    Button {
                        store.send(.cardTapped(id: movie.id))
                    } label: {
                        MovieCell(movie: movie)
                    }
                    .onAppear {
                        store.send(.movieAppeared(id: movie.id))
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
    private static func previewStore(_ state: MoviesListState) -> MoviesStore {
        Store(initialState: state) { _, _ in .none }
    }

    static var loading: some View {
        NavigationStack {
            MoviesView(store: previewStore(.empty))
        }
        .preferredColorScheme(.dark)
    }

    static var error: some View {
        NavigationStack {
            MoviesView(store: previewStore(.error))
        }
        .preferredColorScheme(.dark)
    }

    static var movies3: some View {
        NavigationStack {
            MoviesView(store: previewStore(.movies3))
        }
        .preferredColorScheme(.dark)
    }

    static var movies8: some View {
        NavigationStack {
            MoviesView(store: previewStore(.movies8))
        }
        .preferredColorScheme(.dark)
    }

    static var previews: some View {
        movies8.previewDisplayName("8 Movies")
        movies3.previewDisplayName("3 Movies")
        loading.previewDisplayName("Loading")
        error.previewDisplayName("Error")
    }
}
