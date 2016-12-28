//
//  ColorCalendar.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/17/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import UIKit
import SnapKit


public class ColorCalendarView:UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // MARK: Static constants
    private static let calendarCellReuseIdentifier = "calendarCellReuseIdentifier"
    private static let calendarWeekDaysHeaderCellReuseIdentifier = "calendarWeekDaysHeaderCellReuseIdentifier"
    private static let calendarCellBorderWidth:CGFloat = 1.0
    
    // MARK: instance variables
    
    lazy var calendarCollectionView = UICollectionView(frame:CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var currentMonthLabel = UILabel()
    
    // MARK: Enums
    
    enum CallendarSection: Int {
        case weekdaysNames = 0
        case calendarDays
    }    
    
    // MARK: Properties
    
    var rowHeight:CGFloat {
        get {
            // Weeks + weekdays header
            let totalRow = calendar.weeksPerMonth + 1
            return (calendarCollectionView.frame.height -  (CGFloat(totalRow - 1) * ColorCalendarView.calendarCellBorderWidth)) / CGFloat(totalRow)
        }
    }
    
    var nOfDayCells:Int {
        get {
            return calendar.daysPerWeek * calendar.weeksPerMonth
        }
    }
    
    public var calendar:CalendarHighlights! {
        didSet {
            currentMonthLabel.text = calendar.currentMonthName
        }
    }
    
    // MARK: UIView methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        calendarCollectionView.performBatchUpdates(nil, completion: nil)
    }
    
    
    // MARK: Private API
    
    private func createUI() {
        func createButton(with image:UIImage, and accessibilityLabel:String) -> UIButton {
            let button = UIButton(type: .custom)
            button.setImage(image, for:.normal)
            button.accessibilityLabel = accessibilityLabel
            
            return button
        }
        // This is just plain closure practice/learn closure definition and impl. Not really useful at all:
        typealias CreateButtonClosureType = (UIImage, String) -> (UIButton)
        let createButtonClosure : CreateButtonClosureType = {(image, label) -> UIButton in
            return createButton(with: image, and: label)
        }
        let createButtonConstant : CreateButtonClosureType = createButtonClosure
        let previousMonthButton = createButtonConstant(R.image.leftArrow()!, R.string.localizable.buttonPreviousMonthAccessibilityLabel())
        let nextMonthButton = createButtonConstant(R.image.rightArrow()!, R.string.localizable.buttonNextMonthAccessibilityLabel())
        
        currentMonthLabel.text = R.string.localizable.labelCurrentMonthAccessibilityLabel()
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.register(ColorCalendarCollectionViewCell.self, forCellWithReuseIdentifier: ColorCalendarView.calendarCellReuseIdentifier)
        calendarCollectionView.register(ColorCalendarCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ColorCalendarView.calendarWeekDaysHeaderCellReuseIdentifier)
        calendarCollectionView.delegate = self
       
        self.addSubview(previousMonthButton)
        self.addSubview(nextMonthButton)
        self.addSubview(currentMonthLabel)
        self.addSubview(calendarCollectionView)
        
        previousMonthButton.snp.makeConstraints{(make) in
            make.left.top.equalTo(previousMonthButton.superview!)
        }
        
        nextMonthButton.snp.makeConstraints{(make) in
            make.right.top.equalTo(nextMonthButton.superview!)
        }
        
        currentMonthLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(previousMonthButton)
            make.centerX.equalTo(currentMonthLabel.superview!)
        }
        
        calendarCollectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(calendarCollectionView.superview!)
            make.top.equalTo(previousMonthButton.snp.bottom)
        }
        
        // Add weekdays view
        // let weekdaysSymbols = DateFormatter().veryShortWeekdaySymbols!
    }

    
    // MARK: UICollectionDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch CallendarSection(rawValue:section)! {
        case .weekdaysNames:
            return calendar.daysPerWeek
        case .calendarDays:
            return nOfDayCells
        }
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCalendarView.calendarCellReuseIdentifier,
                                                      for: indexPath) as! ColorCalendarCollectionViewCell
        
        
        switch CallendarSection(rawValue:indexPath.section)! {
        case .weekdaysNames:
            cell.text = calendar.weekdaySymbol(at: indexPath.row)
        case .calendarDays:
            cell.text = "\(calendar.dayNumber(at: indexPath.row))"
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width -  (CGFloat(calendar.daysPerWeek - 1) * ColorCalendarView.calendarCellBorderWidth)) / CGFloat(calendar.daysPerWeek)
        
        return CGSize(width:width, height:rowHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ColorCalendarView.calendarCellBorderWidth
    }
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return ColorCalendarView.calendarCellBorderWidth
    }

}
