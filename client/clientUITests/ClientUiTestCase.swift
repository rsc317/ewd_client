//
//  UiTestHelpers.swift
//  client
//
//  Created by Johannes Grothe on 25.12.24.
//

import XCTest

class ClientUiTestCase: XCTestCase {
    
    var app: XCUIApplication = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments += ["-AppleLanguages", "(de)", "-AppleLocale", "de_DE"]
        app.launch()
    }
    
    func localizedString(forKey key: String.LocalizationValue) -> String? {
        guard let locale = Locale.current.language.languageCode?.identifier else {
            return nil
        }
        let stringKey = String(localized: key)
        let bundle = Bundle(for: type(of: self))
        guard let path = bundle.path(forResource: locale, ofType: "lproj"),
              let localizedBundle = Bundle(path: path),
              let localizedString = localizedBundle.localizedString(forKey: stringKey, value: nil, table: nil) as String? else {
            return nil
        }
        return localizedString
    }
    
    func checkTitle(_ localizeIdentifier: String.LocalizationValue) {
        guard let title = localizedString(forKey: localizeIdentifier) else {
            XCTFail()
            return
        }
        let titleLabel = app.navigationBars.staticTexts[title]
        XCTAssertTrue(titleLabel.exists)
    }
    
    func checkButton(accessibilityIdentifier: String) {
        let button = app.buttons[accessibilityIdentifier]
        XCTAssertTrue(button.exists)
    }
    
    func checkTextfield(accessibilityIdentifier: String) {
        let textField = app.textFields[accessibilityIdentifier]
        XCTAssertTrue(textField.exists)
    }
    
    func checkSecureTextfield(accessibilityIdentifier: String) {
        let textField = app.secureTextFields[accessibilityIdentifier]
        XCTAssertTrue(textField.exists)
    }
}
