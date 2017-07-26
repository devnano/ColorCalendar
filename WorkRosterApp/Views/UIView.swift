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
        if CommandLine.argc < 3 || !NSString(string: CommandLine.arguments[2]).boolValue {
            return
        }
        generateIcon(57)
    }
    
    private func generateIcon(_ dimension: Int) {
        let pointsSize = CGFloat(dimension) / UIScreen.main.scale
        let size = CGSize(width: pointsSize, height: pointsSize)
        let image = generateImage(withSize: size)
        if let data = UIImagePNGRepresentation(image) {
            let filename = imagePath(withDimension: dimension)
            let url = URL(fileURLWithPath: filename)
            do {
                try data.write(to: url)
            } catch let error as NSError {
                print(error.localizedDescription);
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
    
    private func imagePath(withDimension dimension: Int) -> String {
        return "\(iconsDirectory())/icon_\(dimension)x\(dimension).png"
    }
    
    private func generateImage(withSize size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        let wasHidden = self.isHidden
        self.isHidden = false
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        self.drawHierarchy(in: rect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.isHidden = wasHidden
        
        return UIImage(cgImage: (image?.cgImage)!)
    }
}
