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
        return app.navigationBars.buttons["Cancel"]
    }

    private var doneButton: XCUIElement {
        return app.navigationBars.buttons["Done"]
    }

    // MARK: -

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    private func showImagePicker(named name: String) {
        app.tables.cells.staticTexts[name].tap()

        addUIInterruptionMonitor(withDescription: "Photos Permission") { alert -> Bool in
            let button = alert.buttons["OK"]
            if button.exists {
                button.tap()
                return true
            }
            return false
        }

        // Need to interact with the app for the handler to fire
        app.tap()

        // Workaround to tap the permission alert button found via the springboard
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let button = springboard.buttons["OK"]
        if button.exists {
            button.tap()
        }
    }

    func testDefaultStates() {
        showImagePicker(named: "Default appearance")
        XCTAssert(cancelButton.isEnabled)
        XCTAssertFalse(doneButton.isEnabled)
        cancelButton.tap()
    }

    func testImageSelections() {
        showImagePicker(named: "Default appearance")

        let cells = app.collectionViews.children(matching: .cell)
        let first = cells.element(boundBy: 0)
        let second = cells.element(boundBy: 1)
        let third = cells.element(boundBy: 2)
        let forth = cells.element(boundBy: 3)
        let fifth = cells.element(boundBy: 4)

        // Select and deselect an image
        first.tap()
        XCTAssert(first.isSelected)
        XCTAssert(doneButton.isEnabled)
        XCTAssert(first.identifier == "1")

        first.tap()
        XCTAssertFalse(first.isSelected)
        XCTAssertFalse(doneButton.isEnabled)
        XCTAssert(first.identifier.isEmpty)

        // Select images in sequence
        second.tap()
        XCTAssert(second.identifier == "1")

        third.tap()
        XCTAssert(third.identifier == "2")

        forth.tap()
        XCTAssert(forth.identifier == "3")

        // Reorder selections
        third.tap()
        XCTAssert(second.identifier == "1")
        XCTAssert(forth.identifier == "2")

        third.tap()
        XCTAssert(third.identifier == "3")

        fifth.tap()
        XCTAssert(fifth.identifier == "4")

        doneButton.tap()
    }

    func testSwitchingAlbums() {
        showImagePicker(named: "Default appearance")

        app.navigationBars.staticTexts["Camera Roll"].tap()
        app.tables.cells.staticTexts["Favorites"].tap()
        XCTAssert(app.collectionViews.cells.count == 0)

        app.navigationBars["Favorites"].staticTexts["Favorites"].tap()
        app.tables.cells.staticTexts["Camera Roll"].tap()
        XCTAssert(app.collectionViews.cells.count > 0)

        cancelButton.tap()
    }

}
