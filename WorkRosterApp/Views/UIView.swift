//
//  IconGenerator.swift
//  ColorCalendar
//
//  Created by Mariano Heredia on 27/07/17.
//  Copyright © 2017 Kartjuba. All rights reserved.
//

import UIKit


extension UIView {
    
    var asImage: UIImage{
        return generateImage(withSize: self.frame.size)
    }
    
    func generateIconsIfNeeded() {
        if !RostaCommandLine.generateIcons {
            return
        }
        [20, 29, 40, 50, 57, 60, 72, 76, 83.5].forEach { (dimension) in
            generateIcon(dimension)
        }        
    }
    
    private func generateIcon(_ dimension: Float) {
        for scale in 1...3 {
            let scaledDimension = dimension * Float(scale)
            let pointsSize = CGFloat(scaledDimension) / UIScreen.main.scale
            let size = CGSize(width: pointsSize, height: pointsSize)
            let image = generateImage(withSize: size, drawHierarchy: true)
            if let data = UIImagePNGRepresentation(image) {
                let filename = imagePath(withDimension: dimension, scale: scale)
                let url = URL(fileURLWithPath: filename)
                do {
                    try data.write(to: url)
                } catch let error as NSError {
                    print(error.localizedDescription);
                }
            }
        }
    }
    
    private func iconsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory = paths[0]
        
        let iconsDirectory = "\(documentsDirectory)/icons"
        
        do {
            try FileManager.default.createDirectory(atPath: iconsDirectory, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
        
        return iconsDirectory
    }
    
    private func imagePath(withDimension dimension: Float, scale: Int) -> String {
        let dimensionString = dimension.truncatingRemainder(dividingBy: 1)  == 0 ? String(format: "%.0f", dimension) : String(dimension)
        return "\(iconsDirectory())/Icon-App-\(dimensionString)x\(dimensionString)@\(scale)x.png"
    }
    
    private func generateImage(withSize size: CGSize, drawHierarchy: Bool = false) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        let wasHidden = self.isHidden
        self.isHidden = false
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        if drawHierarchy {
            self.drawHierarchy(in: rect, afterScreenUpdates: true)
        } else {
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.isHidden = wasHidden
        
        return UIImage(cgImage: (image?.cgImage)!)
    }
}
