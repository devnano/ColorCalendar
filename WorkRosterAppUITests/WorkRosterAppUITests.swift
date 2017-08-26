//
//  WorkRosterAppUITests.swift
//  WorkRosterAppUITests
//
//  Created by Mariano Heredia on 12/22/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import XCTest

class WorkRosterAppUITests: XCTestCase {
    let app = XCUIApplication()
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app.launch()
        
        // In UI tests it‚Äôs important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPreviousMonthExists() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssert(app.buttons["Previous month"].exists)
        XCTAssert(app.buttons["Next month"].exists)
        XCTAssert(app.buttons["Current month"].exists)        
    }
    
//    func testGenerateLaunchScreen() {
//        let app = XCUIApplication()
//        setupSnapshot(app)
//        app.launch()
//        // Use recording to get started writing UI tests.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        snapshot("LaunchImage")
//        XCUIDevice().orientation = UIDeviceOrientation.landscapeRight
//        snapshot("LaunchImageLandscape")
//
//    }

    func testScreenshots() {
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        snapshot("0LaunchHelpPortrait")
        XCUIDevice().orientation = UIDeviceOrientation.landscapeRight
        snapshot("0LaunchLandscape")
        // Edit Work Sequence TextField
        XCUIApplication().textFields.element(boundBy: 1).tap()
        snapshot("1EditSequenceLandscape")
        XCUIDevice().orientation = UIDeviceOrientation.portrait
        snapshot("1EditSequencePortrait")
        app.buttons["Return"].tap()
        snapshot("0LaunchPortrait")
        // Next Month button
        XCUIApplication().buttons.element(boundBy:1).tap()
        snapshot("0NextMonthPortrait")
        XCUIDevice().orientation = UIDeviceOrientation.landscapeRight
        snapshot("0NextMonthLandscape")
    }
}
