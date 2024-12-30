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
        
        // ensure app is currently authorised.  If the first install is to
        // happen then the settings won't exist yet but that's ok, the test
        // will handle the Location Services prompt and allow.
        app.resetAuthorizationStatus(for: .location)

        let _ = addUIInterruptionMonitor(withDescription: "Darf \"client\" deinen Standort verwenden?") { (alertElement) -> Bool in
            alertElement.buttons["Beim Verwenden der App erlauben"].tap()
            print("ALLOWING LOCATION ACCESS")
            return true
        }
        
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
    
    func checkButton(accessibilityId: String) {
        let button = app.buttons[accessibilityId]
        XCTAssertTrue(button.exists)
    }
    
    func checkTextfield(accessibilityId: String) {
        let textField = app.textFields[accessibilityId]
        XCTAssertTrue(textField.exists)
    }
    
    func checkSecureTextfield(accessibilityId: String) {
        let textField = app.secureTextFields[accessibilityId]
        XCTAssertTrue(textField.exists)
    }
    
    func enterValueIntoTextfield(accessibilityId: String, value: String) {
        let textField = app.textFields[accessibilityId]
        XCTAssertTrue(textField.exists)
        textField.tap()
        textField.typeText(value)
        XCTAssertEqual(textField.value as! String, value, "Text field value is not correct")
    }
    
    func enterValueIntoSecureTextfield(accessibilityId: String, value: String) {
        let textField = app.secureTextFields[accessibilityId]
        XCTAssertTrue(textField.exists)
        textField.tap()
        textField.typeText(value)
    }
    
    func tapButton(accessibilityId: String) {
        let button = app.buttons[accessibilityId]
        XCTAssertTrue(button.exists)
        button.tap()
    }
}
