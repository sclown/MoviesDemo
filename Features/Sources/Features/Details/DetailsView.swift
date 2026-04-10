//
//  DetailsView.swift
//

import SwiftUI
import NukeUI

struct DetailsView: View {
    let movie: MovieDetails

    var body: some View {
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

                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                        Text(movie.rating)
                            .fontWeight(.semibold)
                    }
                    .font(.title3)

                    if let releaseDate = movie.releaseDate, !releaseDate.isEmpty {
                        Text("Release date: \(releaseDate)")
                            .foregroundStyle(.secondary)
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
