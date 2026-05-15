//
//  SearchResultRow.swift
//

import SwiftUI
import NukeUI

struct SearchResultRow: View {
    let movie: SearchCard

    var body: some View {
        HStack(spacing: 12) {
            LazyImage(url: movie.poster) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Rectangle()
                        .foregroundStyle(.quaternary)
                        .overlay {
                            Image(systemName: "film")
                                .foregroundStyle(Color.white.opacity(0.75))
                                .font(.caption2)
                        }
                }
            }
            .frame(width: 36, height: 54)
            .clipShape(RoundedRectangle(cornerRadius: 4))

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.body)
                    .fontWeight(.medium)

                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.caption2)
                        Text(movie.rating)
                            .font(.caption)
                            .foregroundStyle(Color.white.opacity(0.75))
                    }

                    if let date = movie.releaseDate {
                        Text(date)
                            .font(.caption)
                            .foregroundStyle(Color.white.opacity(0.75))
                    }
                }
            }

            Spacer()
        }
    }
}

struct SearchResultRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultRow(movie: .mock)
        .padding()
        .preferredColorScheme(.dark)
    }
}
