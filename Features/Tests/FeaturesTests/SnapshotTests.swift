//
//  File.swift
//

import Foundation
import SnapshotPreviewsCore
import SnapshotTesting
@testable import SnapshottingTests
import SwiftUI
import UIKit
import XCTest

@MainActor
class SnapTests: SnapshotTest {
    private static func hostingController<V: View>(for preview: V) -> UIHostingController<V> {
        let controller = UIHostingController(rootView: preview)
        controller.overrideUserInterfaceStyle = .dark
        return controller
    }
    
    static let previews = FindPreviews.findPreviews(
        included: nil,
        excluded: nil
    )

    override func testPreview(_ discoveredPreview: DiscoveredPreviewAndIndex) {
        let previewType = Self.previews.first { $0.typeName == discoveredPreview.preview.typeName }
        guard let previewType = previewType else {
          XCTFail("Preview type not found")
          return
        }
        let preview = previewType.previews[discoveredPreview.index]
        let controller = Self.hostingController(
            for: AnyView(preview.view()).frame(width: 390, height: 844))
        let basicName = discoveredPreview.preview.displayName ?? ""
        let displayName = preview.displayName ?? ""
        let testName =  "\(basicName)-\(displayName)-\(discoveredPreview.index)"
        assertSnapshot(of: controller, as: .image, testName: testName)
    }
}

