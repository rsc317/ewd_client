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
        checkButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN,
                    localizedId: localizationIdentifiers.SIGNUP)
    }
    
    @MainActor
    func testRegistrationTextfields() throws {
        checkTextfield(accessibilityId: accessibilityIdentifiers.EMAIL_FIELD,
                       localizedId: localizationIdentifiers.EMAIL)
        checkTextfield(accessibilityId: accessibilityIdentifiers.USERNAME_FIELD,
                       localizedId: localizationIdentifiers.USERNAME)
        checkSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                             localizedId: localizationIdentifiers.PASSWORD)
        checkSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_REPEAT_FIELD,
                             localizedId: localizationIdentifiers.PASSWORD_REPEAT)
    }
}
