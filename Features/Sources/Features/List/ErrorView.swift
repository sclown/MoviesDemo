//
//  ErrorView.swift
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label {
                Text("Error", bundle: .module)
            } icon: {
                Image(systemName: "exclamationmark.triangle")
            }
        } description: {
            Text(message)
        } actions: {
            Button(action: onRetry) {
                Text("Retry", bundle: .module)
            }
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(message: "No internet connection. Please check your network settings.") {}
    }
}
