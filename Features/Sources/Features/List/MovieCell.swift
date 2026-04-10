//
//  MovieCell.swift
//

import SwiftUI
import NukeUI

struct MovieCell: View {
    let movie: MovieCard

    var body: some View {
        LazyImage(url: movie.poster) { state in
            Rectangle()
                .foregroundStyle(.quaternary)
                .aspectRatio(2 / 3, contentMode: .fill)
                .overlay {
                    Text(movie.title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(4)
                }
                .overlay {
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        MovieCell(movie: .mock)
            .frame(width: 180)
            .preferredColorScheme(.dark)
    }
}
