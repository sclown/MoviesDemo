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
                .foregroundStyle(.white.opacity(0.65))
                .font(.subheadline)
                .padding(.leading, 12)
                .accessibilityHidden(true)

            TextField(
                "",
                text: $text,
                prompt: Text("Search", bundle: .module)
                    .foregroundStyle(.white.opacity(0.65))
            )
                .focused($isFocused)
                .textFieldStyle(.plain)
                .submitLabel(.search)
                .font(.subheadline)
                .contentShape(Rectangle().inset(by: -10))
                .onTapGesture {
                    isFocused = true
                }
                .padding(.vertical, 10)
                .padding(.trailing, 12)
                .accessibilityValue(text)
                .accessibilityIdentifier("searchField")
        }
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(.white, lineWidth: 0.5))
        .contentShape(.accessibility, Capsule())
        .accessibilityAddTraits(.isSearchField)
        .accessibilityLabel(Text("Search movies", bundle: .module))
        .overlay(alignment: .trailing) {
            if !text.isEmpty {
                Button {
                    onClear()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                }
                .accessibilityLabel(Text("Clear search", bundle: .module))
                .accessibilitySortPriority(1)
                .accessibilityIdentifier("clearSearchButton")
            }
        }
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
