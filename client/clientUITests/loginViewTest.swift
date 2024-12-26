//
//  clientUITests.swift
//  clientUITests
//
//  Created by Johannes Grothe on 23.12.24.
//

import XCTest

final class loginViewTest: ClientUiTestCase {

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    @MainActor
    func testTitle() throws {
        checkTitle(localizationIdentifiers.LOGIN_TITLE)
    }
    
    @MainActor
    func testSignupButton() throws {
        checkButton(accessibilityIdentifier: accessibilityIdentifiers.SIGNUP_BTN)
    }
    
    @MainActor
    func testLoginButton() throws {
        checkButton(accessibilityIdentifier: accessibilityIdentifiers.LOGIN_BTN)
    }
    
    @MainActor
    func testCredentialsTextfields() throws {
        checkTextfield(accessibilityIdentifier: accessibilityIdentifiers.USERNAME_FIELD)
        checkSecureTextfield(accessibilityIdentifier: accessibilityIdentifiers.PASSWORD_FIELD)
    }
}
