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
    
    func checkTitle(_ localizeId: String.LocalizationValue) {
        guard let title = localizedString(forKey: localizeId) else {
            XCTFail()
            return
        }
        let titleLabel = app.navigationBars.staticTexts[title]
        XCTAssertTrue(titleLabel.exists)
    }
    
    func checkButton(accessibilityId: String, localizedId: String.LocalizationValue) {
        let button = app.buttons[accessibilityId]
        XCTAssertTrue(button.exists)
//        XCTAssert(button.title == localizedString(forKey: localizedId))
    }
    
    func checkTextfield(accessibilityId: String, localizedId: String.LocalizationValue) {
        let textField = app.textFields[accessibilityId]
        XCTAssertTrue(textField.exists)
//        XCTAssert(textField.title == localizedString(forKey: localizedId))
    }
    
    func checkSecureTextfield(accessibilityId: String, localizedId: String.LocalizationValue) {
        let textField = app.secureTextFields[accessibilityId]
        XCTAssertTrue(textField.exists)
//        XCTAssert(textField.title == localizedString(forKey: localizedId))
    }
}
