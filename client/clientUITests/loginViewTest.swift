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
    func testFailedLogin() throws {
        let username = "UITest"
        let password = "wrong_password"
        
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.USERNAME_FIELD,
                                value: username)
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                      value: password)
        
        tapButton(accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
        
        /// TODO: this test needs to check the error message when https://github.com/rsc317/ewd_client/issues/34 is implemented

        sleep(3)
        
        let map = app.otherElements[accessibilityIdentifiers.MAP]
        XCTAssert(!map.exists)
    }
    
    @MainActor
    func testSuccessfullLoginWithVerifiedUser() throws {
        let username = "UITest"
        let password = "UI_test123"
        
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.USERNAME_FIELD,
                                value: username)
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                      value: password)
        
        tapButton(accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
        
        sleep(3)
        
        let map = app.otherElements[accessibilityIdentifiers.MAP]
        XCTAssert(map.exists)
    }
    
    @MainActor
    func testSuccessfullLoginWithUnverifiedUser() throws {
        let username = "UITest2"
        let password = "UI_test124"
        let wrong_token = "illegal_token"
        let correct_token = "correct_token"
        
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.USERNAME_FIELD,
                                value: username)
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                      value: password)
        
        tapButton(accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
        
        sleep(1)
        
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.VERIFICATION_TOKEN_FIELD,
                                value: correct_token)
        
        tapButton(accessibilityId: accessibilityIdentifiers.VERIFICATION_BUTTON)
        
        checkButton(accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
    }
}
