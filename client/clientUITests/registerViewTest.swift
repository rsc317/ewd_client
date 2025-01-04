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
    func testPasswordsDoNotMatchCheck() throws {
        let correct_password = "Valid@Password1"
        let mismatched_password = "Mismatch@Password2"
        
        /// Check that the error is not present from the start
        checkStaticTextDoesNotExist(localizationIdentifiers.PASSWORDS_DONT_MATCH)
        
        /// Enter the correct password into the first password field
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                      value: correct_password)
        
        /// Enter a mismatched password into the confirmation password field and check the error
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_REPEAT_FIELD,
                                      value: mismatched_password)
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        checkStaticTextExists(localizationIdentifiers.PASSWORDS_DONT_MATCH)
        
        /// Clear textfield
        clearSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_REPEAT_FIELD)
        
        /// Enter the same password into the confirmation field and check that the error is gone
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_REPEAT_FIELD,
                                      value: correct_password)
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        checkStaticTextDoesNotExist(localizationIdentifiers.PASSWORDS_DONT_MATCH)
    }
    
    @MainActor
    func testPasswordTextfieldChecks() throws {
        let correct_password = "Valid@Password1"
        let short_password = "Short1!"
        let no_special_char_password = "Password1"
        let no_capital_char_password = "valid@password1"
        let invalid_char_password = "Valid@Pass<word"
        
        /// Check that no error is present from the start
        checkStaticTextDoesNotExist(localizationIdentifiers.PASSWORD_TOO_SHORT)
        checkStaticTextDoesNotExist(localizationIdentifiers.PASSWORD_NO_SPECIAL_CHARACTER)
        checkStaticTextDoesNotExist(localizationIdentifiers.PASSWORD_NO_CAPITAL_CHARACTER)
        checkStaticTextDoesNotExist(localizationIdentifiers.PASSWORD_HAS_INVALID_CHARACTER)
        
        /// Enter a short password and check for the corresponding error
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                      value: short_password)
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        checkStaticTextExists(localizationIdentifiers.PASSWORD_TOO_SHORT)
        
        /// Clear textfield
        clearSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD)
        
        /// Enter a password with no special character and check for the corresponding error
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                      value: no_special_char_password,
                                      tap: false)
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        checkStaticTextExists(localizationIdentifiers.PASSWORD_NO_SPECIAL_CHARACTER)
        
        /// Clear textfield
        clearSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD)
        
        /// Enter a password with no capital letter and check for the corresponding error
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                      value: no_capital_char_password,
                                      tap: false)
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        checkStaticTextExists(localizationIdentifiers.PASSWORD_NO_CAPITAL_CHARACTER)
        
        /// Clear textfield
        clearSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD)
        
        /// Enter a password with invalid characters and check for the corresponding error
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                      value: invalid_char_password,
                                      tap: false)
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        checkStaticTextExists(localizationIdentifiers.PASSWORD_HAS_INVALID_CHARACTER)
        
        /// Clear textfield
        clearSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD)
        
        /// Enter a correct password and check that all errors are gone
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                      value: correct_password,
                                      tap: false)
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        checkStaticTextDoesNotExist(localizationIdentifiers.PASSWORD_TOO_SHORT)
        checkStaticTextDoesNotExist(localizationIdentifiers.PASSWORD_NO_SPECIAL_CHARACTER)
        checkStaticTextDoesNotExist(localizationIdentifiers.PASSWORD_NO_CAPITAL_CHARACTER)
        checkStaticTextDoesNotExist(localizationIdentifiers.PASSWORD_HAS_INVALID_CHARACTER)
    }
    
    @MainActor
    func testUsernameTextfieldChecks() throws {
        let correct_username = "user"
        let short_username = "usr" // Less than 4 characters
        
        /// Check that the error is not present from the start
        checkStaticTextDoesNotExist(localizationIdentifiers.USERNAME_TOO_SHORT)
        
        /// Enter a short username and check that the error is displayed
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.USERNAME_FIELD,
                                value: short_username)
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        checkStaticTextExists(localizationIdentifiers.USERNAME_TOO_SHORT)
        
        /// Clear textfield
        clearTextfield(accessibilityId: accessibilityIdentifiers.USERNAME_FIELD)
        
        /// Enter a valid username and check that the error disappears
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.USERNAME_FIELD,
                                value: correct_username)
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        checkStaticTextDoesNotExist(localizationIdentifiers.USERNAME_TOO_SHORT)
    }
    
    @MainActor
    func testEmailTextfieldChecks() throws {
        let correct_mail = "uitest@test.com"
        let illegal_mail_1 = "uitesttest.com"
        let illegal_mail_2 = "uitest@test"
        
        /// Check, that the error is not sent from the start
        checkStaticTextDoesNotExist(localizationIdentifiers.ILLEGAL_MAIL)
        
        /// Enter a wrong email and check that the error is set
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.EMAIL_FIELD,
                                value: illegal_mail_1)
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        checkStaticTextExists(localizationIdentifiers.ILLEGAL_MAIL)
        
        /// Clear textfield
        clearTextfield(accessibilityId: accessibilityIdentifiers.EMAIL_FIELD)
        
        /// Enter a correct email and check that the error is gone
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.EMAIL_FIELD,
                                value: correct_mail)
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        checkStaticTextDoesNotExist(localizationIdentifiers.ILLEGAL_MAIL)
        
        /// Clear textfield
        clearTextfield(accessibilityId: accessibilityIdentifiers.EMAIL_FIELD)
        
        /// Enter a wrong email with a different fault and check that the error is set again
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.EMAIL_FIELD,
                                value: illegal_mail_2)
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        checkStaticTextExists(localizationIdentifiers.ILLEGAL_MAIL)
    }
    
    @MainActor
    func testCompleteSignup() throws {
        let email = "uitest@test.com"
        let username = "UITest_Signup"
        let password = "Testerinski_01"
        let verification_token = "verify_new_user_success"
        
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.EMAIL_FIELD,
                                value: email)
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.USERNAME_FIELD,
                                value: username)
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_FIELD,
                                value: password)
        enterValueIntoSecureTextfield(accessibilityId: accessibilityIdentifiers.PASSWORD_REPEAT_FIELD,
                                value: password)
        
        tapButton(accessibilityId: accessibilityIdentifiers.SIGNUP_BTN)
        
        /// Enter correct verification code into textfield and tap send
        enterValueIntoTextfield(accessibilityId: accessibilityIdentifiers.VERIFICATION_TOKEN_FIELD,
                                value: verification_token)
        tapButton(accessibilityId: accessibilityIdentifiers.SEND_VERIFICATION_CODE_BUTTON)
        
        sleep(2)
        
        let map = app.otherElements[accessibilityIdentifiers.MAP]
        XCTAssert(map.exists)
    }
}
