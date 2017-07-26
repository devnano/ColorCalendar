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
    
    public init(workDays: Int, freeDays: Int) {
        self.workDays = workDays
        self.freeDays = freeDays       
    }
}

public extension ShiftSystem {
    static func *(lhs: ShiftSystem, rhs: Int) -> ShiftSystem {
        return ShiftSystem(workDays: lhs.workDays * rhs, freeDays: lhs.freeDays * rhs)
    }
}

extension ShiftSystem: CustomStringConvertible {
    public var description: String {
        return "(\(workDays):\(freeDays))"
    }
}

extension String {
    public var comaSeparatedComponents: [String] {
        let cs = components(separatedBy: ",").map { component in component.trimmingCharacters(in: .whitespaces) }
        
        return cs;
    }
}

public class ShiftRota: NSObject, NSCoding {
    private static let nameKey = "shiftRotaNameKey"
    private static let formatKey = "shiftRotaFormatKey"
    private (set) public var format: String = ""
    private (set) public var name: String = ""
    
    public lazy var components: [String] = {
        return self.format.comaSeparatedComponents
    }()
    
    public lazy var workShiftSequence: [WorkShift]? = {        
        var sequence: [WorkShift] = []
        
        for component in self.components {
            
            guard let workShift = WorkShift(rawValue:component) else {
                return nil
            }
            
            // Force uniform use of .empty and .free.
            var shift = workShift == .empty ? .free : workShift
            
            sequence.append(shift)
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
        var type: ShiftworkType?
        var rotatingSpeed: RotationSpeed?
        var lastShiftChangeDistance: Int = 0
        var rotationDirection = 1
        var previousRotationDirection = 0
        
        for shift in sequence {
            if !shift.isWorkDay {
                continue
            }
            
            if(previousShift != nil) {
                if shift != previousShift {
                    rotationDirection = previousShift!.rotationDirection(to: shift, prioritizedRotation: rotationDirection)
                    
                    rotationDirection = rotationDirection == 0 ? previousRotationDirection : rotationDirection
                    
                    if rotationDirection != 0 {
                        lastShiftChangeDistance *= rotationDirection
                    }
                    
                    if let speed = rotatingSpeed {
                        if previousRotationDirection != 0 && speed != lastShiftChangeDistance {
                            return .irregular
                        }
                    }
                    rotatingSpeed = lastShiftChangeDistance
                    lastShiftChangeDistance = 0
                    previousRotationDirection = rotationDirection
                }
            }
            
            previousShift = shift
            lastShiftChangeDistance += 1
        }
        
        if let speed = rotatingSpeed {
            type = .rotating(speed)
        } else {
            type = .fixed
            
        }
        
        return type
    }()
    
    public required init?(coder aDecoder: NSCoder) {        
        name = aDecoder.decodeObject(forKey: ShiftRota.nameKey) as! String
        format = aDecoder.decodeObject(forKey: ShiftRota.formatKey) as! String
    }
    
    public init(name: String, format: String, locale: Locale = Locale(identifier: "EN_us")) {
        super.init()
        self.name = name
        self.format = self.localizedFormat(format: format.replacingOccurrences(of: " ", with: ","), formatter: {workShift in workShift?.rawValue}, locale: locale)
    }
    
    public convenience init(_ format: String) {
        self.init(name: "", format: format)
    }
    
    public init(name: String, workSequence: [WorkShift]) {
        super.init()
        self.name = name
        workShiftSequence = workSequence
        format = ShiftRota.localizedFormat(from: workSequence)
    }
    
    public convenience init(_ sequence: [WorkShift]) {
        self.init(name: "", workSequence: sequence)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: ShiftRota.nameKey)
        aCoder.encode(format, forKey: ShiftRota.formatKey)
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? ShiftRota? else {
            return false
        }
        
        guard let otherSequence = other?.workShiftSequence else {
            return false
        }
        
        guard let sequence = workShiftSequence else {
            return false
        }
        
        return sequence == otherSequence
    }
    
    public override var hash: Int {
        return format.hash
    }
    
    public func localizedFormat(locale: Locale) -> String {
        
        let formatter: (WorkShift?) -> String? = {
            workShift in workShift?.localizedRawValue(locale: locale)
        }
        return self.localizedFormat(format: self.format, formatter: formatter, locale: Locale(identifier: "en"))
    }
    
    // MARK: Private API
    
    private func localizedFormat(format: String,formatter: (WorkShift?) -> String?, locale: Locale) -> String {
        let result = format.uppercased().comaSeparatedComponents.map({component in (formatter(WorkShift.from(rawValue: component, locale: locale)) ?? component) }).joined(separator: ",")

        return result        
    }
}

public typealias GetWorkShiftColor = (WorkShift?) -> (textColor: UIColor, backgroundColor: UIColor)


public extension ShiftRota {
    public func attributedFormat(getShiftRotaColor: GetWorkShiftColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self.localizedFormat(locale: .current))
        let wholeStringRange = NSRange(location: 0, length: format.characters.count)

        var location = 0
        attributedString.addAttribute(NSBackgroundColorAttributeName, value: UIColor.clear, range: wholeStringRange)
                
        for (index, component) in components.enumerated() {
            let workShift = workShiftSequence?[index]
            let textColors = getShiftRotaColor(workShift)
            let component = component
            let length = component.characters.count
            var range = NSRange(location: location, length: length)
            
            if workShift == nil {
                range = wholeStringRange
            }
            
            location = range.location + length + 1 // adding 1 because seprator ,
            attributedString.addAttribute(NSBackgroundColorAttributeName, value: textColors.backgroundColor, range: range)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: textColors.textColor, range: range)
            
            if workShift == nil {
                break;
            }            
        }       
        
        return attributedString
    }
    
    public static func localizedFormat(from workShiftSequence: [WorkShift]) -> String {
        return workShiftSequence.map({workShift in workShift.rawValue}).joined(separator: ",")
    }
}
