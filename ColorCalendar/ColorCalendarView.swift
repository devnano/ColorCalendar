//
//  ColorCalendar.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 12/17/16.
//  Copyright © 2016 Kartjuba. All rights reserved.
//

import UIKit
import SnapKit


public class ColorCalendarView:UIView, UICollectionViewDataSource {
    // MARK: Static constants
    fileprivate static let calendarCellReuseIdentifier = "calendarCellReuseIdentifier"
    
    // MARK: Properties
    
    // MARK: UIView methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createUI()
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
        let currentMonthLabel = UILabel()
        let calendarCollectionView = UICollectionView(frame:CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        currentMonthLabel.text = R.string.localizable.labelCurrentMonthAccessibilityLabel()
        currentMonthLabel.text = R.string.localizable.labelCurrentMonthAccessibilityLabel()
        
        calendarCollectionView.dataSource = self
        calendarCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ColorCalendarView.calendarCellReuseIdentifier)
       
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
        return 1
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCalendarView.calendarCellReuseIdentifier,
                                                      for: indexPath)
        cell.backgroundColor = UIColor.black
        
        return cell
    }

}
