//
//  WorkShiftTests.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 2/26/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import XCTest
@testable import Roster

class WorkShiftTests: XCTestCase {
    
    func testIsWorkDay() {
        XCTAssert(WorkShift.day.isWorkDay)
        XCTAssert(WorkShift.evening.isWorkDay)
        XCTAssert(WorkShift.night.isWorkDay)
        XCTAssert(WorkShift.morning.isWorkDay)
        XCTAssert(!WorkShift.free.isWorkDay)
        XCTAssert(!WorkShift.empty.isWorkDay)
    }
}
