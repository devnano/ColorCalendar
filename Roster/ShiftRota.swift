//
//  ShiftRota.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/5/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation


public struct ShiftSystem {
    var workDays: Int
    var freeDays: Int
}

extension ShiftSystem {
    static func *(lhs: ShiftSystem, rhs: Int) -> ShiftSystem {
        return ShiftSystem(workDays: lhs.workDays * rhs, freeDays: lhs.freeDays * rhs)
    }
}

extension ShiftSystem: CustomStringConvertible {
    public var description: String {
        return "(\(workDays):\(freeDays))"
    }
}

public class ShiftRota: NSCoding {
    private static let nameKey = "shiftRotaNameKey"
    private static let formatKey = "shiftRotaFormatKey"
    private (set) public var format: String = ""
    private (set) public var name: String = ""
    
    public lazy var components: [String] = {
        let cs = self.format.components(separatedBy: ",")
        
        return cs;
    }()
    
    public lazy var workShiftSequence: [WorkShift]? = {        
        var sequence: [WorkShift] = []
        
        for component in self.components {
            let trimComponent = component.trimmingCharacters(in: .whitespaces)
            guard let workShift = WorkShift(rawValue:trimComponent) else {
                return nil
            }
            sequence.append(workShift)
        }
        
        return sequence
    }()
    
    public lazy var shiftSystem: ShiftSystem? = {
        guard let sequence = self.workShiftSequence else {
            return nil
        }
        
        let workDays: Int = sequence.map({workShift in workShift.isWorkDay ? 1 : 0}).reduce(0, +)
        let freeDays = sequence.count - workDays        
        
        return ShiftSystem(workDays: workDays, freeDays: freeDays)
    }()
    
    public lazy var shiftworkType: ShiftworkType? = {
        guard let sequence = self.workShiftSequence else {
            return nil
        }
        
        var previousShift: WorkShift?
        var type: ShiftworkType = .irregular
        var rotating: RotatingDirection?
        var rotatingSpeed: RotationSpeed?
        var lastShiftChangeDistance: Int = 0
        var anyRotation = false
        
        for shift in sequence {
            if !shift.isWorkDay {
                continue
            }
            
            if(previousShift != nil) {
                if shift != previousShift {
                    rotatingSpeed = lastShiftChangeDistance
                    lastShiftChangeDistance = 0
                }
            }
            
            previousShift = shift
            lastShiftChangeDistance += 1
        }
        
        if let speed = rotatingSpeed {
            type = .rotating(.clockwise(rotatingSpeed!))
        } else {
            if !anyRotation {
                type = .fixed
            }
        }
        
        return type
    }()
    
    public required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: ShiftRota.nameKey) as! String
        format = aDecoder.decodeObject(forKey: ShiftRota.formatKey) as! String
    }
    
    public init(name: String, format: String) {
        self.name = name
        self.format = format.uppercased()
    }
    
    public convenience init(_ format: String) {
        self.init(name: "", format: format)
    }
    
    public init(name: String, workSequence: [WorkShift]) {
        self.name = name
        workShiftSequence = workSequence
        format = workSequence.map({workShift in workShift.rawValue}).joined(separator: ",")
    }
    
    public convenience init(_ sequence: [WorkShift]) {
        self.init(name: "", workSequence: sequence)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: ShiftRota.nameKey)
        aCoder.encode(name, forKey: ShiftRota.formatKey)
    }
}

typealias GetWorkShiftColor = (WorkShift) -> (textColor: UIColor, backgroundColor: UIColor)


public extension ShiftRota {
    public func attributedFormat(getShiftRotaColor: GetWorkShiftColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: format)
        let wholeStringRange = NSRange(location: 0, length: format.characters.count)
        
        guard let sequence = workShiftSequence else {
            // TODO: delegate error color too
            
            attributedString.addAttribute(NSBackgroundColorAttributeName, value:  UIColor.red, range: wholeStringRange)
            return attributedString
        }
        var location = 0
        attributedString.addAttribute(NSBackgroundColorAttributeName, value:  UIColor.white, range: wholeStringRange)
        
        for (index, workShift) in sequence.enumerated() {
            let textColors = getShiftRotaColor(workShift)
            let component = components[index]
            let length = component.characters.count
            let range = NSRange(location: location, length: length)
            
            location = range.location + length + 1 // adding 1 because seprator ,
            attributedString.addAttribute(NSBackgroundColorAttributeName, value: textColors.backgroundColor, range: range)
            
        }       
        
        return attributedString
    }
}
