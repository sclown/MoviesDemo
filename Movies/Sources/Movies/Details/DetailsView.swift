//
//  DetailsView.swift
//

import SwiftUI
import NukeUI
import MoviesCore

public struct DetailsView: View {
    let movie: MovieDetails

    public init(movie: MovieDetails) {
        self.movie = movie
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                LazyImage(url: movie.poster) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Rectangle()
                            .foregroundStyle(.quaternary)
                            .aspectRatio(2 / 3, contentMode: .fit)
                            .overlay {
                                ProgressView()
                            }
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .accessibilityLabel(Text("Movie's poster", bundle: .module))

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text(movie.rating)
                            .fontWeight(.semibold)
                    }
                    .font(.title3)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text("Rating", bundle: .module))
                    .accessibilityValue(movie.rating)

                    if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
                        Text("Release date: \(releaseDate)", bundle: .module)
                            .foregroundStyle(Color.white.opacity(0.75))
                    }

                    Text(movie.overview)
                        .font(.body)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        DetailsView(movie: .mock)
    }
    .preferredColorScheme(.dark)
}
