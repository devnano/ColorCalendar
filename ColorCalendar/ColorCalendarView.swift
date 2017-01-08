//
//  ColorCalendar.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/17/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import UIKit
import SnapKit


public class ColorCalendarView:UIView {
    // MARK: - Static constants
    fileprivate static let calendarCellReuseIdentifier = "calendarCellReuseIdentifier",
                           calendarWeekDaysHeaderCellReuseIdentifier = "calendarWeekDaysHeaderCellReuseIdentifier"
    fileprivate static let calendarCellBorderWidth:CGFloat = 1.0
    
    // MARK: - Properties
    
    lazy var calendarCollectionView = UICollectionView(frame:.zero, collectionViewLayout: UICollectionViewFlowLayout())
    lazy var currentMonthLabel = UILabel()
    
    var rowHeight:CGFloat {
        // Weeks + weekdays header
        let totalRow = calendar.weeksPerMonth + 1
        return (calendarCollectionView.frame.height -  (CGFloat(totalRow - 1) * ColorCalendarView.calendarCellBorderWidth)) / CGFloat(totalRow)
    }
    
    var nOfDayCells:Int {
        return calendar.daysPerWeek * calendar.weeksPerMonth        
    }
    
    public var calendar:CalendarHighlights! {
        didSet {
            updateCurrentMonthLabel()
        }
    }

    
    // MARK: - Enums
    
    enum CalendarSection: Int {
        case weekdaysNames = 0
        case calendarDays
    }
    
    // MARK: - UIView methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        calendarCollectionView.performBatchUpdates(nil, completion: nil)
    }
    
    
    // MARK: - Private API
    
    private func createUI() {
        
        let monthSwitcherView = createMonthSwitcherView()
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.register(ColorCalendarCollectionViewCell.self, forCellWithReuseIdentifier: ColorCalendarView.calendarCellReuseIdentifier)
        calendarCollectionView.register(ColorCalendarWeekdaySymbolCollectionViewCell.self, forCellWithReuseIdentifier:ColorCalendarView.calendarWeekDaysHeaderCellReuseIdentifier)
        calendarCollectionView.delegate = self
        
        addSubview(monthSwitcherView)
        addSubview(calendarCollectionView)
        
        
        monthSwitcherView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(monthSwitcherView.superview!)
        }
        
        calendarCollectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(calendarCollectionView.superview!)
            make.top.equalTo(monthSwitcherView.snp.bottom)
        }
    }
    
    private func createMonthSwitcherView() -> UIView {
        let monthSwitcherView = UIView()
        monthSwitcherView.backgroundColor = calendarColors.monthSwitcherBackgroundColor
        
        func createButton(image:UIImage, accessibilityLabel:String, action:Selector) -> UIButton {
            let button = UIButton(type: .custom)
            button.setImage(image, for:.normal)
            button.accessibilityLabel = accessibilityLabel
            button.addTarget(self, action: action, for: .touchUpInside)
            
            return button
        }
        
        // This is just plain closure practice/learn closure definition and impl. Not really useful at all:
        typealias CreateButtonClosureType = (UIImage, String, Selector) -> (UIButton)
        let createButtonClosure: CreateButtonClosureType = {(image, label, action) -> UIButton in
            return createButton(image: image, accessibilityLabel: label, action: action)
        }
        let createButtonConstant: CreateButtonClosureType = createButtonClosure
        let previousMonthButton = createButtonConstant(R.image.leftArrow()!, R.string.localizable.buttonPreviousMonthAccessibilityLabel(), #selector(switchToPreviousMonth))
        let nextMonthButton = createButtonConstant(R.image.rightArrow()!, R.string.localizable.buttonNextMonthAccessibilityLabel(), #selector(switchToNextMonth))
        
        currentMonthLabel.accessibilityLabel = R.string.localizable.labelCurrentMonthAccessibilityLabel()
        
        monthSwitcherView.addSubview(previousMonthButton)
        monthSwitcherView.addSubview(nextMonthButton)
        monthSwitcherView.addSubview(currentMonthLabel)
        
        previousMonthButton.snp.makeConstraints{(make) in
            make.left.top.bottom.equalTo(previousMonthButton.superview!)
        }
        
        nextMonthButton.snp.makeConstraints{(make) in
            make.right.top.equalTo(nextMonthButton.superview!)
        }
        
        currentMonthLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(previousMonthButton)
            make.centerX.equalTo(currentMonthLabel.superview!)
        }
        
        return monthSwitcherView
    }
    
    private func reloadCalendar() {
        calendarCollectionView.reloadData()
        updateCurrentMonthLabel()
    }
    
    private func updateCurrentMonthLabel() {
         currentMonthLabel.text = "\(calendar.currentMonthName) \(calendar.currentYear)"
    }
    
    @objc private func switchToNextMonth() {
        calendar.forwardOneMonth()
        reloadCalendar()
    }
    
    @objc private func switchToPreviousMonth() {
        calendar.backwardOneMonth()
        reloadCalendar()
    }
}

extension ColorCalendarView: UICollectionViewDataSource {

    // MARK: - UICollectionDataSource
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch CalendarSection(rawValue:section)! {
        case .weekdaysNames:
            return calendar.daysPerWeek
        case .calendarDays:
            return nOfDayCells
        }
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = CalendarSection(rawValue:indexPath.section) == .weekdaysNames ? ColorCalendarView.calendarWeekDaysHeaderCellReuseIdentifier : ColorCalendarView.calendarCellReuseIdentifier
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                      for: indexPath) as! BaseColorCalendarCollectionViewCell
        
        switch CalendarSection(rawValue:indexPath.section)! {
        case .weekdaysNames:
            cell.text = calendar.weekdaySymbol(at: indexPath.row)            
        case .calendarDays:
            let dayCell = cell as! ColorCalendarCollectionViewCell
            let dateComponents = calendar.dateComponents(at: indexPath.row)
            cell.text = "\(dateComponents.components.day!)"
            let dayColorsFunc = dateComponents.isCurrentMonth ? calendarColors.currentMonthDayColors : calendarColors.otherMonthsDayColors;
            let date = NSCalendar.current.date(from: dateComponents.components)!
            let dayColors = dayColorsFunc(date)
            
            dayCell.set(dayColors: dayColors)            
        }
        
        return cell
    }
}

extension ColorCalendarView:  UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDelegateFlowLayout

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
