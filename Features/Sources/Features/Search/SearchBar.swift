//
//  SearchBar.swift
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @FocusState.Binding var isFocused: Bool
    let onClear: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
                .font(.subheadline)

            TextField("Search movies...", text: $text)
                .focused($isFocused)
                .textFieldStyle(.plain)
                .submitLabel(.search)
                .font(.subheadline)

            if !text.isEmpty {
                Button {
                    onClear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(.white, lineWidth: 0.5))
    }
}

struct SearchBar_Previews: PreviewProvider {
    struct Wrapper: View {
        @State var text = "Batman"
        @FocusState var isFocused: Bool

        var body: some View {
            SearchBar(text: $text, isFocused: $isFocused) {}
                .padding()
        }
    }

    static var previews: some View {
        Wrapper()
            .preferredColorScheme(.dark)
    }
}
