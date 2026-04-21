//
//  MoviesDemoApp.swift
//

import MainNavigation
import SwiftUI

@main
struct MoviesDemoApp: App {
    var body: some Scene {
        WindowGroup {
            MainNavigation()
                .preferredColorScheme(.dark)
        }
    }
}
