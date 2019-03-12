//
//  String.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 11/21/18.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import Foundation
import UIKit

enum StringError: Error {
    case dataCorrupted
}
extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func dateFormatter(_ format: String) -> String {
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "uk")
        dateFormatter.dateFormat = format
        
        let date = dateFormatterGet.date(from: self)
        let dateUtc = dateFormatter.string(from: date!)
        
        return dateUtc
    }
    
    func dateFormatter() -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        let date: Date? = dateFormatterGet.date(from: self)
        let dateUtc = dateFormatter.string(from: date!)
        return  dateUtc
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) == self.range(of: self)
    }
    
    func widthWithConstrainedHeight(_ height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat? {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func estimatedSizeFor(_ text: String) -> CGRect {
        let size = CGSize(width: 450.0, height: 1000.0)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .regular)]
        return NSString(string: text).boundingRect(with: size, options: options, attributes: attribute, context: nil)
    }
    
    func formateNumberToStringInDecimalFormat(_ number: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = true
        return formatter.string(from: number)!
    }
}
