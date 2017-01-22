//
//  WorkScheme.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 1/5/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import Foundation

public class WorkScheme: NSCoding {
    private static let nameKey = "workSchemeNameKey"
    private static let formatKey = "workSchemeFormatKey"
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
    
    
    public required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: WorkScheme.nameKey) as! String
        format = aDecoder.decodeObject(forKey: WorkScheme.formatKey) as! String
    }
    
    public init(name: String, format: String) {
        self.name = name
        self.format = format.uppercased()
    }
    
    public convenience init(_ format: String) {
        self.init(name: "", format: format)
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: WorkScheme.nameKey)
        aCoder.encode(name, forKey: WorkScheme.formatKey)
    }
}

typealias GetWorkShiftColor = (WorkShift) -> (textColor: UIColor, backgroundColor: UIColor)


public extension WorkScheme {
    public func attributedFormat(getWorkSchemeColor: GetWorkShiftColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: format)
        guard let sequence = workShiftSequence else {
            // TODO: delegate error color too
            let range = NSRange(location: 0, length: format.characters.count)
            attributedString.addAttribute(NSBackgroundColorAttributeName, value:  UIColor.red, range: range)            
            return attributedString
        }
        var location = 0
        
        for (index, workShift) in sequence.enumerated() {
            let textColors = getWorkSchemeColor(workShift)
            let component = components[index]
            let length = component.characters.count
            let range = NSRange(location: location, length: length)
            
            
            
            location = range.location + length + 1 // adding 1 because seprator ,
            attributedString.addAttribute(NSBackgroundColorAttributeName, value: textColors.backgroundColor, range: range)
            
        }
        
        return attributedString
    }
}
