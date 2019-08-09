//
//  ColorCalendar.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/17/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import UIKit
import SnapKit


//@IBDesignable
public class ColorCalendarView: UIView {
    // MARK: - Static constants
    fileprivate static let calendarCellReuseIdentifier = "calendarCellReuseIdentifier",
                           calendarWeekDaysHeaderCellReuseIdentifier = "calendarWeekDaysHeaderCellReuseIdentifier"
    fileprivate static let calendarCellBorderWidth: CGFloat = 0.0
    fileprivate static let overlayViewTag: Int = 982982892
    
    
    // MARK: - Properties
    
    public var monthSwitcherHeightProportion: CGFloat = 0.15
    public var calendarTitle: String?
    
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
            make.height.equalToSuperview().multipliedBy(monthSwitcherHeightProportion)
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
        let totalRow = calendar.numberOfWeeks + 1
        return (calendarCollectionView.frame.height -  (CGFloat(totalRow - 1) * ColorCalendarView.calendarCellBorderWidth)) / CGFloat(totalRow)
    }
    
    var nOfDayCells: Int {
        return calendar.daysPerWeek * calendar.numberOfWeeks        
    }
    
    // MARK: - Public Properties
    
    public var calendar: CalendarLayout! {
        didSet {
            updatecurrentMonthTitleButton()
            setNeedsLayout()
        }
    }    
    
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
        reloadCalendar()
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
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeCalendarForward))
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeCalendarBackward))
        
        swipeLeft.direction = .left
        swipeRight.direction = .right
        
        addGestureRecognizer(swipeLeft)
        addGestureRecognizer(swipeRight)
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
        let title = calendarTitle ?? calendar.title
        currentMonthTitleButton.setTitle(title, for: .normal)
    }
    
    @objc private func swipeCalendarForward() {
        switchToNextMonth()
        delegate?.colorCalendarDidSwipeCalendarForward(self)
    }
    
    @objc private func swipeCalendarBackward() {
        switchToPreviousMonth()
        delegate?.colorCalendarDidSwipeCalendarBackward(self)
    }
    
    @objc private func switchToNextMonth() {
        calendar.moveCalendarForward()
        reloadCalendar()
        delegate?.colorCalendarDidMoveCalendarForward(self)
    }
    
    @objc private func switchToPreviousMonth() {
        calendar.moveCalendarBackward()
        reloadCalendar()
        delegate?.colorCalendarDidMoveCalendarBackward(self)
    }
    
    @objc private func onMonthTitleTap() {
        delegate?.colorCalendarDidTapMonthName(self)
    }
}

public protocol ColorCalendarViewDelegate: class {
    func colorCalendarDidMoveCalendarForward(_ calendar: ColorCalendarView)
    func colorCalendarDidMoveCalendarBackward(_ calendar: ColorCalendarView)
    func colorCalendarDidSwipeCalendarForward(_ calendar: ColorCalendarView)
    func colorCalendarDidSwipeCalendarBackward(_ calendar: ColorCalendarView)
    func colorCalendarDidTapMonthName(_ calendar: ColorCalendarView)
    func colorCalendar(_ calendar: ColorCalendarView, didTapWeekdaySymbolAtIndex index: Int)
    func colorCalendar(_ calendar: ColorCalendarView, didTapCalendarDay date: Date, isWithinCurrentCalendarPeriod: Bool, in window: UIWindow, from frame: CGRect)
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
            let dayColorsFunc = dateComponents.isWithinCurrentCalendarPeriod ? CalendarColors.calendarColors.currentMonthDayColors : CalendarColors.calendarColors.otherMonthsDayColors
            let date = NSCalendar.current.date(from: dateComponents.components)!
            let dayColors = dayColorsFunc(date)
            
            cell.onTap({ (cell) in
                let window = self.window!
                let frame = window.convert(cell.frame, from: cell.superview!)
                self.delegate?.colorCalendar(self, didTapCalendarDay: date, isWithinCurrentCalendarPeriod: dateComponents.isWithinCurrentCalendarPeriod, in: window, from: frame)
            })            
            
            dayCell.set(dayColors: dayColors, font: CalendarFonts.calendarFonts.fontFor(date: date))
            
            cell.accessibilityLabel = dataSource.value.colorCalendar(self, accesibilityLabelForDate: date)
            if let overlayView = dataSource.value.colorCalendar?(self, overlayViewFor: date) {
                overlayView.tag = ColorCalendarView.overlayViewTag
                cell.addSubview(overlayView)
                overlayView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            } else {
                cell.viewWithTag(ColorCalendarView.overlayViewTag)?.removeFromSuperview()
            }
        }
        
        return cell
    }
}

extension ColorCalendarView:  UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionViewDelegateFlowLayout

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width -  (CGFloat(calendar.daysPerWeek - 1) * ColorCalendarView.calendarCellBorderWidth)) / CGFloat(calendar.daysPerWeek)
        
        return CGSize(width:width.rounded(.down), height:rowHeight)
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
