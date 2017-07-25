//
//  UITests.swift
//  UITests
//
//  Created by Christopher Brind on 25/07/2017.
//  Copyright © 2017 DuckDuckGo. All rights reserved.
//

import XCTest

class UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let app = XCUIApplication()
        if app.buttons.element(matching: .button, identifier: "FireMini").exists {
            app.buttons["FireMini"].tap()
            app.sheets.buttons["Forget All Tabs and Data"].tap()
        }
        
        snapshot("Main")
        
        app.buttons["Bookmarks"].tap()
        snapshot("Bookmarks")
        
    }

}
