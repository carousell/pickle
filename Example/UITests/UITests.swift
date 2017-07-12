//
//  This source file is part of the carousell/pickle open source project
//
//  Copyright © 2017 Carousell and the project authors
//  Licensed under Apache License v2.0
//
//  See https://github.com/carousell/pickle/blob/master/LICENSE for license information
//  See https://github.com/carousell/pickle/graphs/contributors for the list of project authors
//

import XCTest

class UITests: XCTestCase {

    private lazy var app: XCUIApplication = XCUIApplication()

    private var cancelButton: XCUIElement {
        return app.navigationBars["Camera Roll"].buttons["Cancel"]
    }

    private var doneButton: XCUIElement {
        return app.navigationBars["Camera Roll"].buttons["Done"]
    }

    // MARK: -

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    private func showImagePicker(named name: String) {
        app.tables.cells.staticTexts[name].tap()

        addUIInterruptionMonitor(withDescription: "Pickle Example") { alert -> Bool in
            let button = alert.buttons["OK"]
            if button.exists {
                button.tap()
                return true
            }
            return false
        }

        // need to interact with the app for the handler to fire
        app.tap()
    }

    func testDefaultStates() {
        showImagePicker(named: "Default appearance")
        XCTAssertTrue(cancelButton.isEnabled)
        XCTAssertFalse(doneButton.isEnabled)
        cancelButton.tap()
    }

    func testImageSelections() {
        showImagePicker(named: "Default appearance")

        let collectionViewsQuery = app.collectionViews
        let first = collectionViewsQuery.children(matching: .cell).element(boundBy: 0)
        let second = collectionViewsQuery.children(matching: .cell).element(boundBy: 1)
        let third = collectionViewsQuery.children(matching: .cell).element(boundBy: 2)
        let forth = collectionViewsQuery.children(matching: .cell).element(boundBy: 3)
        let fifth = collectionViewsQuery.children(matching: .cell).element(boundBy: 4)

        // Select and deselect an image
        first.tap()
        XCTAssert(first.staticTexts["1"].exists)
        XCTAssertTrue(doneButton.isEnabled)

        first.tap()
        XCTAssertFalse(first.staticTexts["1"].exists)
        XCTAssertFalse(doneButton.isEnabled)

        // Select images in sequence
        second.tap()
        XCTAssert(second.staticTexts["1"].exists)

        third.tap()
        XCTAssert(third.staticTexts["2"].exists)

        forth.tap()
        XCTAssert(forth.staticTexts["3"].exists)

        // Reorder selections
        third.tap()
        XCTAssert(second.staticTexts["1"].exists)
        XCTAssert(forth.staticTexts["2"].exists)

        third.tap()
        XCTAssert(third.staticTexts["3"].exists)

        fifth.tap()
        XCTAssert(fifth.staticTexts["4"].exists)

        doneButton.tap()
    }

    func testSwitchingAlbums() {
        showImagePicker(named: "Default appearance")

        app.navigationBars["Camera Roll"].staticTexts["Camera Roll"].tap()
        app.tables.cells.staticTexts["Favorites"].tap()
        XCTAssert(app.collectionViews.cells.count == 0)

        app.navigationBars["Favorites"].staticTexts["Favorites"].tap()
        app.tables.cells.staticTexts["Camera Roll"].tap()
        XCTAssert(app.collectionViews.cells.count == 5)

        cancelButton.tap()
    }

}
