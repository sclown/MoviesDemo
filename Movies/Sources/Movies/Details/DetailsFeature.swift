//
//  DetailsFeature.swift
//

import ComposableArchitecture
import MoviesCore

@Reducer
public struct DetailsFeature {
    @ObservableState
    public struct State: Equatable {
        public let movie: MovieDetails

        public init(movie: MovieDetails) {
            self.movie = movie
        }
    }

    public enum Action {}

    public init() {}

    public var body: some ReducerOf<Self> {
        EmptyReducer()
    }
}
