import Testing
import Foundation
import SwiftUI

@testable import Features
@testable import MainNavigation

@MainActor
struct MainViewModelTests {
    @Test func initialPathIsEmpty() {
        let vm = MainViewModel()
        #expect(vm.path.isEmpty)
    }

    @Test func navigateAppendsToPath() {
        let vm = MainViewModel()

        vm.navigate(to: .mock)

        #expect(vm.path.count == 1)
    }

    @Test func resetClearsPath() {
        let vm = MainViewModel()

        vm.navigate(to: .mockWith(id: 1))
        vm.reset(to: NavigationPath())

        #expect(vm.path.isEmpty)
    }
}
