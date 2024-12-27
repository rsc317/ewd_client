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
        checkButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN,
                    localizedId: localizationIdentifiers.SIGNUP)
    }
    
    @MainActor
    func testLoginButton() throws {
        checkButton(accessibilityId: accessibilityIdentifiers.LOGIN_BTN,
                    localizedId: localizationIdentifiers.LOGIN)
    }
    
    @MainActor
    func testCredentialsTextfields() throws {
        checkTextfield(accessibilityId: accessibilityIdentifiers.USERNAME_FIELD,
                       localizedId: localizationIdentifiers.USERNAME)
        checkSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                             localizedId: localizationIdentifiers.PASSWORD)
    }
}
