//
//  ColorCalendarDayView.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 5/17/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit
import Macaw

@IBDesignable
open class ColorCalendarDayView: MacawView {
    
    // MARK: - Properties
    
    private var onTapFunc:((ColorCalendarDayView) -> ())?
    
    @IBInspectable
    public var text: String?
    public var textSize: CGFloat?
    public var font: UIFont?
    public var insetsProportion: Double = 0.0
   
    
    public var dayColors: DayColors? {
        didSet {
            setNeedsLayout()
        }
    }    

    @IBInspectable
    public var textColor: UIColor? {
        get {
            return dayColors?.textColor ?? nil
        }
        set {
            let newColor = newValue ?? .clear
            if dayColors == nil {
                dayColors = DayColors(textColor: newColor, backgroundColor: .clear)
            } else {
                dayColors?.textColor = newColor
            }
        }
    }
    
    @IBInspectable
    public var textBackgroundColor: UIColor? {
        get {
            return dayColors?.backgroundColor ?? nil
        }
        set {
            let newColor = newValue ?? .clear
            if dayColors == nil {
                dayColors = DayColors(textColor: .clear, backgroundColor: newColor)
            } else {
                dayColors?.backgroundColor = newColor
            }
        }
    }
    
    @IBInspectable
    public var borderColor: UIColor = .clear

    // MARK: - UIView
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        guard let colors = dayColors else {
            return
        }
        
        let size = frame.size
        let width = Double(size.width)
        let height = Double(size.height)
        if size.width == 0 || size.height == 0 {
            return          
        }
        
        let theText = text ?? ""
        
        backgroundColor = .clear
        
        let tColor = macawColor(from: colors.textColor)!
        
        let radiusProportion: Double = 0.45 - insetsProportion
        let radius = Double(min(width * radiusProportion, height * radiusProportion))
        let centerX = Double(width / 2)
        let centerY = Double(height / 2)
        
        
        let backgroundFillShape = Shape(form: Rect(x: 0, y: 0, w: width, h: height), fill: macawColor(from: backgroundColor))
        let round = Circle(cx: centerX, cy: centerY, r: radius)
        let backgroundShape = Shape(form: round,
                                    fill: macawColor(from: colors.backgroundColor),
                                    stroke: Stroke(fill: macawColor(from : self.borderColor)!))
        let characterText = Text(text: theText, font: macawFont(from: createFont()), fill: tColor, align: .mid, baseline: .mid, place: Transform.move(dx: centerX, dy: centerY))
        
        let group = Group(
            contents: [
                backgroundFillShape,
                backgroundShape,
                characterText
            ]
        )
        
        self.node = group
        if onTapFunc != nil {
            onTap(onTapFunc!)
        }
    }
    
    // MARK: - Public API
    
    public func onTap(_ f: @escaping (ColorCalendarDayView) -> ())  {
        onTapFunc = f
        self.node.onTap { (event) in
            f(self)
        }
    }
    
    
    // MARK: - Private API
    
    private func macawColor(from uiColor: UIColor?) -> Color? {
        guard let color = uiColor else {
            return nil
        }
        
        let ciColor = CIColor(color: color)
        
        return Color.rgba(r: Int(ciColor.red*255), g: Int(ciColor.green*255), b: Int(ciColor.blue*255), a: Double(ciColor.alpha))
    }
    
    private func macawFont(from uiFont: UIFont) -> Font {
        return Font(name: uiFont.fontName, size: Int(uiFont.pointSize))
    }
    
    open func createFont() -> UIFont {
        var theTextSize = textSize ?? 20
        theTextSize = min(theTextSize, min(frame.size.width, frame.size.height))
        
        if font != nil {
            return UIFont(name: font!.fontName, size: theTextSize)!
        }
       
        
        
        return CalendarFonts.calendarFonts.defaultFont(size: theTextSize)
    }
}

