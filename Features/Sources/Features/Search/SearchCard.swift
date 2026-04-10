//
//  SearchCard.swift
//

import Foundation

struct SearchCard: Identifiable {
    let id: Int
    let title: String
    let rating: String
    let releaseDate: String?
    let poster: URL?
}

extension SearchCard {
    static var mock: Self {
        .mockWith(id: 1)
    }

    static func mockWith(id: Int) -> Self {
        Self(
            id: id,
            title: "Test movie \(id)",
            rating: "7.5",
            releaseDate: "2025-06-15",
            poster: nil
        )
    }
}
