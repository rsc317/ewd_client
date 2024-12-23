//
//  clientUITests.swift
//  clientUITests
//
//  Created by Johannes Grothe on 23.12.24.
//

import XCTest

final class loginViewTest: XCTestCase {
    
    private var app: XCUIApplication = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false

        app.launch()
    }

    @MainActor
    func testStaticElements() throws {
        let titleLabel = app.staticTexts["Einloggen"]
        XCTAssertTrue(titleLabel.exists, "Der Titel sollte 'Einloggen' auf der Bildschirmansicht anzeigen.")
    }
}
