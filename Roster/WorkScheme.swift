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
    private static let formatKey = "workSchemeNameKey"
    public var name:String = ""
    public var format:String = ""
    
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
