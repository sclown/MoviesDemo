//
//  MoviesView.swift
//

import ComposableArchitecture
import SwiftUI
import MoviesCore

public struct MoviesView: View {
    let store: StoreOf<MoviesFeature>

    public init(store: StoreOf<MoviesFeature>) {
        self.store = store
    }

    private var cards: [MovieCard] {
        store.movies.map(MovieCard.init(from:))
    }

    public var body: some View {
        ZStack {
            if store.isLoading {
                LoadingView()
            } else if let error = store.errorMessage {
                ErrorView(message: error) {
                    store.send(.onAppear)
                }
            } else {
                movieGrid
            }
        }
        .navigationTitle(Text("Popular Movies", bundle: .module))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            store.send(.onAppear)
        }
    }

    private var movieGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(cards) { movie in
                    Button {
                        store.send(.movieTapped(id: movie.id))
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
    private static func view(_ state: MoviesFeature.State) -> some View {
        NavigationStack {
            MoviesView(store: Store(initialState: state) { MoviesFeature() })
        }
        .preferredColorScheme(.dark)
    }

    static var previews: some View {
        view(.movies8).previewDisplayName("8 Movies")
        view(.movies3).previewDisplayName("3 Movies")
        view(.loading).previewDisplayName("Loading")
        view(.error).previewDisplayName("Error")
    }
}
