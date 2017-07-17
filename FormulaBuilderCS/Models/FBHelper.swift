//
//  FBHelper.swift
//  FormulaBuilderCS
//
//  Created by PFIdev on 2/7/17.
//  Copyright © 2017 orgname. All rights reserved.
//

import UIKit

public enum ButtonType {
    case eye
    case lock
    case add
    case favorite
    case expand
}

class FBHelper: NSObject {
    
    // cache view controller tag
    class func cacheTag(_ tag: Int) {
        UserDefaults.standard.set(tag, forKey: kViewControllerTag)
    }
    
    class func getTag() -> Int {
        return UserDefaults.standard.object(forKey: kViewControllerTag) as! Int
    }
    
    // calculate label text width
    class func widthOf(_ label: UILabel) -> CGFloat {
        let labelFrame = label.text!.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: label.frame.size.height), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil)
        
        return labelFrame.size.width + 10 // add more space
    }
    
    class func setCellButtonImage(sender: UIButton, type: ButtonType, isSelected: Bool) {
        let imageName = imageNameFromType(type)
        
        sender.isSelected = isSelected
        
        if isSelected {
            sender.setImage(UIImage(named: imageName + "_selected"), for: .selected)
        } else {
            sender.setImage(UIImage(named: imageName), for: .normal)
        }
    }
    
    class func clickedCellButton(sender: UIButton, type: ButtonType) {
        let imageName = imageNameFromType(type)
        
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(UIImage(named: imageName), for: .normal)
        } else {
            sender.isSelected = true
            sender.setImage(UIImage(named: imageName + "_selected"), for: .selected)
        }
    }
    
    class func imageNameFromType(_ type: ButtonType) -> String {
        var imageName = "eye"
        
        switch type {
        case .add:
            imageName = "add"
        case .lock:
            imageName = "lock"
        case .favorite:
            imageName = "favorite"
        case .expand:
            imageName = "profile_add"
        default:
            break
        }
        
        return imageName
    }
    
    class func formattedDateString(_ date: Date) -> String {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = NSTimeZone(abbreviation: "UTC") as TimeZone!
        dateFormat.dateFormat = "MMM.dd.yyyy"
        dateFormat.timeZone = NSTimeZone.system
        return dateFormat.string(from: date)
    }
}

public extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

public extension Date {
    static func timeIntervalToStringHumanReadableDate(timeInterval : Double) -> String{
        let date : Date = Date(timeIntervalSince1970: timeInterval)
        return dateToStringHumanReadableDate(date: date)
    }
    
    static func dateToStringHumanReadableDate(date : Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func dateToStringTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}

public extension Array {
    func chunk(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
}
