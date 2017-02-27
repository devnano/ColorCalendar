//
//  WorkShift.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/4/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

public enum WorkShift: String{
    // TODO: analyze if this could be easily refactored to work / free cases with String associated types and use pattern matching in switches referencing it.
    case night = "N"
    case morning = "M"
    case day = "D"
    case evening = "E"
    case free = "X"
    case empty = ""
}

public extension WorkShift {
    public var isWorkDay: Bool {
        return !WorkShift.freeShifts.contains(self)
    }
    
    public static let threeShiftsPerDay: [WorkShift] = [.morning, .day, .night]
    public static let twoShiftsPerDay: [WorkShift] = [.day, .night]
    public static let fourShiftsPerDay: [WorkShift] = [.morning, .day, .evening, .night]
    public static let freeShifts: [WorkShift] = [.free, .empty]
    public static let allWorkShifts = fourShiftsPerDay
}


public typealias RotationSpeed = Int

public enum RotatingDirection {
    case clockwise(RotationSpeed)
    case counterclockwise(RotationSpeed)
}

public extension RotatingDirection {
    var rotationSpeed: RotationSpeed {
        switch self {
        case let .clockwise(speed):
            return speed
        case let .counterclockwise(speed):
            return speed
        }
    }
}

extension RotatingDirection {
    public static func ==(lhs: RotatingDirection, rhs: RotatingDirection) -> Bool {
        switch (lhs, rhs) {
        case (let .clockwise(lhsSpeed), let .clockwise(rhsSpeed)):
            return lhsSpeed == rhsSpeed
        case (let .counterclockwise(lhsSpeed), let .counterclockwise(rhsSpeed)):
            return lhsSpeed == rhsSpeed
        default:
            return false
        }
    }
}

public enum ShiftworkType {
    case fixed
    case rotating(RotatingDirection)
    case irregular
}

extension ShiftworkType: Equatable {
    public static func ==(lhs: ShiftworkType, rhs: ShiftworkType) -> Bool {
        switch (lhs, rhs) {
        case (.fixed, .fixed):
            return true
        case (let .rotating(lhsSpeed), let .rotating(rhsSpeed)):
            return lhsSpeed == rhsSpeed
        default:
            return false
        }        
    }
}

public extension ShiftworkType {
    var isRotating: Bool {
        switch self {
        case .rotating(_):
            return true
        default:
            return false
        }
    }
    
    var rotatingDirection: RotatingDirection? {
        switch self {
        case let .rotating(direction):
            return direction
        default:
            return nil
        }
    }
}


public extension Array {
    public func ciruclarNextElement(_ element: WorkShift) -> WorkShift? {
        let index = (self as NSArray).index(of: element)
        
        if index == NSNotFound {
            return nil
        }
        
        let nextIndex = (index + 1) % count
        
        return (self as NSArray).object(at: nextIndex) as? WorkShift
    }
}
