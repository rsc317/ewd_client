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
        app = XCUIApplication()

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
        
        resetWiremockScenarios()
        
        app.launch()
        
        awaitLocationRequestDialog()
    }
    
    override func tearDownWithError() throws {
        app.terminate()

        // Clear UserDefaults
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
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
    
    func checkStaticTextExists(_ localizeId: String.LocalizationValue) {
        guard let text = localizedString(forKey: localizeId) else {
            XCTFail()
            return
        }
        let label = app.staticTexts[text]
        XCTAssertTrue(label.exists)
    }
    
    func checkStaticTextDoesNotExist(_ localizeId: String.LocalizationValue) {
        guard let text = localizedString(forKey: localizeId) else {
            XCTFail()
            return
        }
        let label = app.staticTexts[text]
        XCTAssertFalse(label.exists)
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
    
    func clearTextfield(accessibilityId: String) {
        let textField = app.textFields[accessibilityId]
        XCTAssertTrue(textField.exists)
        if !textField.isEnabled {
            textField.tap()
        }
        
        guard let stringValue = textField.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        textField.typeText(deleteString)
    }
    
    func enterValueIntoTextfield(accessibilityId: String, value: String) {
        let textField = app.textFields[accessibilityId]
        XCTAssertTrue(textField.exists)
        
        textField.tap()
        textField.typeText(value)
        XCTAssertEqual(textField.value as! String, value, "Text field value is not correct")
    }
    
    func clearSecureTextfield(accessibilityId: String) {
        let textField = app.secureTextFields[accessibilityId]
        XCTAssertTrue(textField.exists)
        if !textField.isEnabled {
            textField.tap()
        }
        
        guard let stringValue = textField.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        textField.typeText(deleteString)
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
    
    func awaitLocationRequestDialog() {
        // Wait for the location permission alert to appear
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let locationAlert = springboard.alerts.firstMatch

        let exists = locationAlert.waitForExistence(timeout: 6) // Adjust timeout as needed
        XCTAssertTrue(exists, "Location permission alert did not appear")
    }
    
    func resetWiremockScenarios() {
        guard let url = URL(string: "http://localhost:8443/__admin/scenarios/reset") else {
            print("Ungültige URL")
            XCTFail()
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Fehler beim Senden des Requests: \(error)")
                XCTFail()
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                print("HTTP-Statuscode: \(statusCode)")
                if statusCode != 200 {
                    print("Scenarios could not be reset properly, got \(statusCode)")
                    XCTFail()
                    return
                }
            }
        }

        task.resume()
    }
}
