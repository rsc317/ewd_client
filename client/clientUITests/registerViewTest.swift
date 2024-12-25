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
        app.buttons[accessibility_SIGNUP_BTN].tap()
    }

    @MainActor
    func testTitle() throws {
        let titleLabel = app.navigationBars.staticTexts["Registrieren"]
        XCTAssertTrue(titleLabel.exists)
    }
    
    @MainActor
    func testRegistrationButton() throws {
        let button = app.buttons[accessibility_SIGNUP_BTN]
        XCTAssertTrue(button.exists)
    }
    
    @MainActor
    func testRegistrationTextfields() throws {
        let mail = app.textFields[accessibility_EMAIL_FIELD]
        XCTAssertTrue(mail.exists)
        
        let username = app.textFields[accessibility_USERNAME_FIELD]
        XCTAssertTrue(username.exists)
        
        let password = app.secureTextFields[accessibility_PASSWORD_FIELD]
        XCTAssertTrue(password.exists)
        
        let password_repeat = app.secureTextFields[accessibility_PASSWORD_REPEAT_FIELD]
        XCTAssertTrue(password_repeat.exists)
    }
}
