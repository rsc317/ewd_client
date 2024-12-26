//
//  clientUITests.swift
//  clientUITests
//
//  Created by Johannes Grothe on 23.12.24.
//

import XCTest

final class registerViewTest: ClientUiTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
        app.buttons[accessibilityIdentifiers.SIGNUP_BTN].tap()
    }

    @MainActor
    func testTitle() throws {
        checkTitle(localizationIdentifiers.SIGNUP_TITLE)
    }
    
    @MainActor
    func testRegistrationButton() throws {
        checkButton(accessibilityIdentifier: accessibilityIdentifiers.SIGNUP_BTN)
    }
    
    @MainActor
    func testRegistrationTextfields() throws {
        checkTextfield(accessibilityIdentifier: accessibilityIdentifiers.EMAIL_FIELD)
        checkTextfield(accessibilityIdentifier: accessibilityIdentifiers.USERNAME_FIELD)
        checkSecureTextfield(accessibilityIdentifier: accessibilityIdentifiers.PASSWORD_FIELD)
        checkSecureTextfield(accessibilityIdentifier: accessibilityIdentifiers.PASSWORD_REPEAT_FIELD)
    }
}
