//
//  ColorCalendarViewTests.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 2/08/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

import XCTest
@testable import ColorCalendar

class ColorCalendarViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDefaultCalendarHighlightRowHeightZero() {
        let colorCalendar = ColorCalendarView()
        XCTAssert(colorCalendar.rowHeight == 0)
    }

}
