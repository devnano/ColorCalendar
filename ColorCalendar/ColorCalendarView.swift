//
//  ColorCalendar.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/17/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import UIKit
import SnapKit


@IBDesignable
public class ColorCalendarView: UIView {
    // MARK: - Static constants
    fileprivate static let calendarCellReuseIdentifier = "calendarCellReuseIdentifier",
                           calendarWeekDaysHeaderCellReuseIdentifier = "calendarWeekDaysHeaderCellReuseIdentifier"
    fileprivate static let calendarCellBorderWidth:CGFloat = 0.0
    
    // MARK: - Properties
    
    lazy var calendarCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame:.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.register(ColorCalendarCollectionViewCell.self, forCellWithReuseIdentifier: ColorCalendarView.calendarCellReuseIdentifier)
        collectionView.register(ColorCalendarWeekdaySymbolCollectionViewCell.self, forCellWithReuseIdentifier:ColorCalendarView.calendarWeekDaysHeaderCellReuseIdentifier)
        collectionView.delegate = self
        
        self.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.monthSwitcherView.snp.bottom)
        }
        
        collectionView.backgroundColor = CalendarColors.calendarColors.backgroundColor
        
        return collectionView
    }()
    
    lazy var monthSwitcherView: UIView = {
        let switcherView = self.createMonthSwitcherView()
        self.addSubview(switcherView)
        switcherView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.15)
        }
        
        return switcherView
    }()
    
    lazy var currentMonthTitleButton: UIButton = {
        let button = UIButton()
        
        button.addTarget(self, action: #selector(onMonthTitleTap), for: .touchUpInside)
        
        return button
    }()
    
    var rowHeight: CGFloat {
        // Weeks + weekdays header
        let totalRow = calendar.weeksPerMonth + 1
        return (calendarCollectionView.frame.height -  (CGFloat(totalRow - 1) * ColorCalendarView.calendarCellBorderWidth)) / CGFloat(totalRow)
    }
    
    var nOfDayCells: Int {
        return calendar.daysPerWeek * calendar.weeksPerMonth        
    }
    
    // MARK: - Public Properties
    
    public var calendar: CalendarHighlights = CalendarHighlights(Date())
    
    public weak var delegate: ColorCalendarViewDelegate?
    
    public var dataSource: Lazy<ColorCalendarViewDataSource> = Lazy({return DefaultColorCalendarViewDataSource()})
    
    // MARK: - Public API
    
    public func hideMonthSwitcher() {
        monthSwitcherView.isHidden = true
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
    
    // MARK: - Public Methods    
    
    public func reloadCalendar() {
        calendarCollectionView.reloadData()
        updatecurrentMonthTitleButton()
    }
    
    // MARK: - Private API
    
    private func createUI() {
        self.backgroundColor = CalendarColors.calendarColors.backgroundColor
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(switchToNextMonth))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(switchToPreviousMonth))
        
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        addGestureRecognizer(swipeLeft)
        addGestureRecognizer(swipeRight)
        reloadCalendar()
    }
    
    private func createMonthSwitcherView() -> UIView {
        let monthSwitcherView = UIView()
        let monthSwitcherColors = CalendarColors.calendarColors.monthSwitcherColor
        monthSwitcherView.backgroundColor = monthSwitcherColors.backgroundColor
        currentMonthTitleButton.setTitleColor(monthSwitcherColors.textColor, for: .normal)
        currentMonthTitleButton.titleLabel!.font = CalendarFonts.calendarFonts.boldFont(size: 20)
        
        func createButton(image:UIImage, accessibilityLabel:String, action:Selector) -> UIButton {
            let button = UIButton(type: .custom)
            
            button.setImage(image.withRenderingMode(.alwaysTemplate), for:.normal)
            button.accessibilityLabel = accessibilityLabel
            button.addTarget(self, action: action, for: .touchUpInside)
            button.imageView?.contentMode = .scaleAspectFit            
            button.imageView?.tintColor = CalendarColors.calendarColors.defaultTextColor
            
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
        
        
        
        currentMonthTitleButton.accessibilityLabel = R.string.localizable.labelCurrentMonthAccessibilityLabel()
        
        monthSwitcherView.addSubview(previousMonthButton)
        monthSwitcherView.addSubview(nextMonthButton)
        monthSwitcherView.addSubview(currentMonthTitleButton)
        
        previousMonthButton.snp.makeConstraints{(make) in
            make.left.top.bottom.equalToSuperview()
        }
        
        nextMonthButton.snp.makeConstraints{(make) in
            make.right.top.bottom.equalToSuperview()
        }
        
        currentMonthTitleButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        currentMonthTitleButton.titleLabel!.minimumScaleFactor = 0.1
        currentMonthTitleButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        return monthSwitcherView
    }
    
    private func updatecurrentMonthTitleButton() {
         currentMonthTitleButton.setTitle("\(calendar.currentMonthName) \(calendar.currentYear)", for: .normal)
    }
    
    @objc private func switchToNextMonth() {
        calendar.forwardOneMonth()
        reloadCalendar()
        delegate?.colorCalendarDidSwitchForwardOneMonth(self)
    }
    
    @objc private func switchToPreviousMonth() {
        calendar.backwardOneMonth()
        reloadCalendar()
        delegate?.colorCalendarDidSwitchBackwardOneMonth(self)
    }
    
    @objc private func onMonthTitleTap() {
        delegate?.colorCalendarDidTapMonthName(self)
    }
}

public protocol ColorCalendarViewDelegate: class {
    func colorCalendarDidSwitchForwardOneMonth(_ calendar: ColorCalendarView)
    func colorCalendarDidSwitchBackwardOneMonth(_ calendar: ColorCalendarView)
    func colorCalendarDidTapMonthName(_ calendar: ColorCalendarView)
    func colorCalendar(_ calendar: ColorCalendarView, didTapWeekdaySymbolAtIndex index: Int)
    func colorCalendar(_ calendar: ColorCalendarView, didTapCalendarDay date: Date, isCurrentMonth: Bool)
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
        
        let row = indexPath.row
        
        switch CalendarSection(rawValue:indexPath.section)! {
        case .weekdaysNames:
            
            cell.text = calendar.weekdaySymbol(at: row)
            cell.set(dayColors: CalendarColors.calendarColors.weekdaySymbolColor, font: CalendarFonts.calendarFonts.weekdaysSymbolFont)
            cell.onTap({ (cell) in
                self.delegate?.colorCalendar(self, didTapWeekdaySymbolAtIndex: row)
            })
        case .calendarDays:
            let dayCell = cell as! ColorCalendarCollectionViewCell
            let dateComponents = calendar.dateComponents(at: row)
            cell.text = "\(dateComponents.components.day!)"
            let dayColorsFunc = dateComponents.isCurrentMonth ? CalendarColors.calendarColors.currentMonthDayColors : CalendarColors.calendarColors.otherMonthsDayColors
            let date = NSCalendar.current.date(from: dateComponents.components)!
            let dayColors = dayColorsFunc(date)
            
            cell.onTap({ (cell) in
                 self.delegate?.colorCalendar(self, didTapCalendarDay: date, isCurrentMonth: dateComponents.isCurrentMonth)
            })            
            
            dayCell.set(dayColors: dayColors, font: CalendarFonts.calendarFonts.fontFor(date: date))
            
            cell.accessibilityLabel = dataSource.value.colorCalendar(self, accesibilityLabelForDate: date)
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
