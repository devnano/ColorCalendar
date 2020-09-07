//
//  ColorCalendarDayView.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 5/17/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit

@IBDesignable
open class ColorCalendarDayView: UIButton {
    
    // MARK: - Properties
    
    private var onTapFunc:((ColorCalendarDayView) -> ())?
    private var circleLayer: CAShapeLayer!
    private var textLayer: CATextLayer!
    
    @IBInspectable
    public var text: String?
    public var textSize: CGFloat?
    public var textFont: UIFont?
    public var insetsProportion: CGFloat = 0.0
    
   
    
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
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let colors = dayColors else {
            return
        }
        
        let size = frame.size
        let width = CGFloat(size.width)
        let height = CGFloat(size.height)
        if size.width == 0 || size.height == 0 {
            return
        }

        let theText = text ?? ""
        
        backgroundColor = .clear

        
        let radiusProportion: CGFloat = 0.4 - insetsProportion
        let radius = CGFloat(min(width * radiusProportion, height * radiusProportion))
        let shapeSide = CGFloat(2.0 * radius)
        let circleFrame = CGRect(x: (width - shapeSide)/2, y: (height - shapeSide)/2, width: shapeSide, height: shapeSide).integral
        if circleLayer == nil {
            circleLayer = CAShapeLayer()
            circleLayer.path = UIBezierPath(roundedRect: circleFrame, cornerRadius: radius).cgPath
            circleLayer.fillColor = colors.backgroundColor.cgColor
            circleLayer.strokeColor = self.borderColor.cgColor
            self.layer.addSublayer(circleLayer)
        }
        
        if textLayer == nil {
            let font = createFont()
            textLayer = CATextLayer()
            textLayer.font = font
            textLayer.fontSize = font.pointSize
            textLayer.frame = circleFrame.offsetBy(dx: 0, dy: (circleFrame.height - font.pointSize) / 2)
            
            textLayer.alignmentMode = .center
            
            layer.addSublayer(textLayer)
        }
        textLayer.foregroundColor = colors.textColor.cgColor
        textLayer.string = theText
    }
    
    // MARK: - Public API
    
    public func onTap(_ f: @escaping (ColorCalendarDayView) -> ())  {
        onTapFunc = f
        addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    
    // MARK: - Private API
    
    open func createFont() -> UIFont {
        var theTextSize = textSize ?? 20
        theTextSize = min(theTextSize, min(frame.size.width, frame.size.height))
        
        if textFont != nil {
            return UIFont(name: textFont!.fontName, size: theTextSize)!
        }
        
        return CalendarFonts.calendarFonts.defaultFont(size: theTextSize)
    }
    
    @objc func buttonAction(sender: UIButton!) {
        onTapFunc!(self)
    }
}

