//
//  ColorCalendarUITests.swift
//  ColorCalendarUITests
//
//  Created by Mariano Heredia on 3/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest

class ColorCalendarUITests: XCTestCase {
    
    var app: XCUIApplication!
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testColorCalendarExists()
    {
        app.tables.staticTexts["ColorCalendarViewExample"].tap()
        XCTAssert(app.otherElements["ColorCalendarView"].exists)
    }
//    func testMonthTextIsNotEmpty()
//    {
//        let colorCalendarView = app.otherElements["ColorCalendarView"]
//        XCTAssert(colorCalendarView.exists)
//    }
    
    
    func testPreviousMonthExists() {
//        let colorCalendarView = app.otherElements["ColorCalendarView"]
//        XCTAssert(colorCalendarView.buttons["Previous month"].exists)
    }
    
    func testNextMonthExists() {
        
//        XCTAssert(app.buttons["Next month"].exists)
    }
    func testCurrentMonthExists() {
        
//        XCTAssert(app.buttons["Current month"].exists)
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

    
//    func testColorCalendarExists()
//    {
//        let colorCalendarView = app.otherElements["ColorCalendarView"]
//        XCTAssert(colorCalendarView.exists)
//    }
//    
//     colorCalendarView.frame.size
    
}
