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
    
    public func rotationDirection(to workShift: WorkShift, prioritizedRotation: Int = 1) -> Int {
        var next: WorkShift = self
        var previous: WorkShift = self
        assert(WorkShift.allWorkShifts.contains(workShift))
        
        repeat {
            next = WorkShift.allWorkShifts.ciruclarNextElement(next)!
            previous = WorkShift.allWorkShifts.ciruclarPreviousElement(previous)!
            
            if next == workShift && previous == workShift {
                // Undefined direction
                return 0
            }
            
            if prioritizedRotation == 1 {
                if next == workShift {
                    return 1
                }
                
                if previous == workShift {
                    return -1
                }
            } else {
                if previous == workShift {
                    return -1
                }
                
                if next == workShift {
                    return 1
                }
            }            
            
            // We are sure workShift is contained in allWorkShifts array.
        } while (true)
    }
    
    public static let threeShiftsPerDay: [WorkShift] = [.morning, .day, .night]
    public static let twoShiftsPerDay: [WorkShift] = [.day, .night]
    public static let fourShiftsPerDay: [WorkShift] = [.morning, .day, .evening, .night]
    public static let freeShifts: [WorkShift] = [.free, .empty]
    public static let allWorkShifts = fourShiftsPerDay
}


public typealias RotationSpeed = Int


public enum ShiftworkType {
    case fixed
    case rotating(RotationSpeed)
    case irregular
}

extension ShiftworkType: Equatable {
    public static func ==(lhs: ShiftworkType, rhs: ShiftworkType) -> Bool {
        switch (lhs, rhs) {
        case (.fixed, .fixed):
            return true
        case (.irregular, .irregular):
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
    
    var rotatingSpeed: RotationSpeed? {
        switch self {
        case let .rotating(speed):
            return speed
        default:
            return nil
        }
    }
}


public extension Array {
    public func ciruclarNextElement(_ element: WorkShift) -> WorkShift? {
        return circularAccess(element) {(index) in (index + 1) % count}
    }
    
    public func ciruclarPreviousElement(_ element: WorkShift) -> WorkShift? {
        return circularAccess(element) {(index) in index - 1 < 0 ? count - 1 : index - 1}
    }
    
    private func circularAccess(_ element: WorkShift, nextIndexStrategy: (Int)->Int) -> WorkShift? {
        let index = (self as NSArray).index(of: element)
        
        if index == NSNotFound {
            return nil
        }
        
        let nextIndex = nextIndexStrategy(index)
        let next = (self as NSArray).object(at: nextIndex) as? WorkShift
        
        return next
    }
}
