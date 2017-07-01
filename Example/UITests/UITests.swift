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

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launch()
    }

    func testLaunch() {
        app.tables.cells.staticTexts["Default appearance"].tap()

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
        app.navigationBars["Camera Roll"].buttons["Cancel"].tap()
    }

}
