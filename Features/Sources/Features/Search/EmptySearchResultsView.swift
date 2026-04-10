//
//  EmptySearchResultsView.swift
//

import SwiftUI

struct EmptySearchResultsView: View {
    let query: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("No results for \"\(query)\"")
                .font(.headline)
            Text("Try a different search term")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

struct EmptySearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySearchResultsView(query: "xyzzy")
            .preferredColorScheme(.dark)
    }
}
