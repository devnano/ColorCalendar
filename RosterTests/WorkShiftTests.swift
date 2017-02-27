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
    
    func testArrayNextCircular() {
        let array: [WorkShift] = [.day, .night, .evening, .morning]
        
        XCTAssert(array.ciruclarNextElement(.day) == .night)
        XCTAssert(array.ciruclarNextElement(.morning) == .day)
    }
    
    func testArrayPreviousCircular() {
        let array: [WorkShift] = [.day, .night, .evening, .morning]
        
        XCTAssert(array.ciruclarPreviousElement(.day) == .morning)
        XCTAssert(array.ciruclarPreviousElement(.morning) == .evening)
    }
    
    func testRotationDirection() {
        XCTAssert(WorkShift.night.rotationDirection(to: .morning) == 1)
        XCTAssert(WorkShift.morning.rotationDirection(to: .night) == -1)
        XCTAssert(WorkShift.day.rotationDirection(to: .night) == 1)
        XCTAssert(WorkShift.night.rotationDirection(to: .day) == 1)
        XCTAssert(WorkShift.day.rotationDirection(to: .morning) == -1)
    }
}
