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
    func testLoginWithVerifiedUser() throws {
        let username = "UITest"
        let correct_password = "testerinski"
        let wrong_password = "errorrino"
        
        checkStaticTextDoesNotExist(localizationIdentifiers.WRONG_CREDENTIALS)
        
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.USERNAME_FIELD,
                                value: username)
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                      value: wrong_password)
        
        tapButton(accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
        
        sleep(1)
        
        checkStaticTextExists(localizationIdentifiers.WRONG_CREDENTIALS)
        
        var map = app.otherElements[accessibilityIdentifiers.MAP]
        XCTAssert(!map.exists)
        
        clearSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD)
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                      value: correct_password)
        
        tapButton(accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
        
        sleep(1)
        
        map = app.otherElements[accessibilityIdentifiers.MAP]
        XCTAssert(map.exists)
    }
    
    @MainActor
    func testVerifyUnverifiedUser() throws {
        let username = "UITest_Unverified"
        let password = "testerinski"
        let wrong_token = "verify_unverified_user_failure"
        let correct_token = "verify_unverified_user_success"
        
        /// Login to User
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.USERNAME_FIELD,
                                value: username)
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                      value: password)
        
        tapButton(accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
        
        sleep(1)
        
        /// Enter wrong code into popup field
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.VERIFICATION_TOKEN_FIELD,
                                value: wrong_token)
        
        tapButton(accessibilityId: accessibilityIdentifiers.VERIFICATION_BUTTON)
        
        /// Login again
        tapButton(accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
        
        sleep(1)
        
        /// Enter correct  code into popup field this time
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.VERIFICATION_TOKEN_FIELD,
                                value: correct_token)
        
        tapButton(accessibilityId: accessibilityIdentifiers.VERIFICATION_BUTTON)
        
        /// Login again
        tapButton(accessibilityId: accessibilityIdentifiers.LOGIN_BTN)
        
        sleep(1)
        
        let map = app.otherElements[accessibilityIdentifiers.MAP]
        XCTAssert(map.exists)
    }
}
