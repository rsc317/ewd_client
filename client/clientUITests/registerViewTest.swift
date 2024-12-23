//
//  clientUITests.swift
//  clientUITests
//
//  Created by Johannes Grothe on 23.12.24.
//

import XCTest

final class registerViewTest: XCTestCase {
    
    private var app: XCUIApplication = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launch()
        app.buttons["Registrieren!"].tap()
    }

    @MainActor
    func testStaticElements() throws {
        let titleLabel = app.staticTexts["Registrieren"]
        XCTAssertTrue(titleLabel.exists, "Der Titel sollte 'Registrieren' auf der Bildschirmansicht anzeigen.")
    }
}
