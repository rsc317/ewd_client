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
    func testTitle() throws {
        let titleLabel = app.navigationBars.staticTexts["Anmelden"]
        XCTAssertTrue(titleLabel.exists)
    }
    
    @MainActor
    func testSignupButton() throws {
        let button = app.buttons[accessibility_SIGNUP_BTN]
        XCTAssertTrue(button.exists)
    }
    
    @MainActor
    func testLoginButton() throws {
        let button = app.buttons[accessibility_LOGIN_BTN]
        XCTAssertTrue(button.exists)
    }
    
    @MainActor
    func testCredentialsTextfields() throws {
        let textField = app.textFields[accessibility_USERNAME_FIELD]
        XCTAssertTrue(textField.exists)
        
        let secureTextField = app.secureTextFields[accessibility_PASSWORD_FIELD]
        XCTAssertTrue(secureTextField.exists)
    }
}
