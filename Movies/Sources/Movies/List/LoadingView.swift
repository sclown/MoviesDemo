//
//  LoadingView.swift
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView {
            Text("Loading movies…", bundle: .module)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
