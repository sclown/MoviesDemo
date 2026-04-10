//
//  MoviesDemoUITests.swift
//

import XCTest

final class MoviesDemoUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    @MainActor
    func testMoviesGridAppearsOnLaunch() {
        let navBar = app.navigationBars["Popular Movies"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 10))
    }

    @MainActor
    func testSearchBarExists() {
        let searchField = app.textFields["Search movies..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
    }

    @MainActor
    func testTapMovieOpensDetails() {
        let firstCell = app.scrollViews.buttons.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()

        let backButton = app.navigationBars.buttons.firstMatch
        XCTAssertTrue(backButton.waitForExistence(timeout: 5))
    }

    @MainActor
    func testSearchShowsResults() {
        let searchField = app.textFields["Search movies..."]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))

        searchField.tap()
        searchField.typeText("Batman")

        let resultCell = app.buttons.element(boundBy: 0)
        XCTAssertTrue(resultCell.waitForExistence(timeout: 5))
    }

    @MainActor
    func testNavigateBackFromDetails() {
        let firstCell = app.scrollViews.buttons.firstMatch
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10))
        firstCell.tap()

        let backButton = app.navigationBars.buttons.firstMatch
        XCTAssertTrue(backButton.waitForExistence(timeout: 5))
        backButton.tap()

        let navBar = app.navigationBars["Popular Movies"]
        XCTAssertTrue(navBar.waitForExistence(timeout: 5))
    }
}
