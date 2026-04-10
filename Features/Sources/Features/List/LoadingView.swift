//
//  LoadingView.swift
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView("Loading movies...")
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
