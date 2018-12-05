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
    
    static var hryvniaSign: String {
        return "₴"
    }
    
    var int: Int {
        return Int(self) ?? 0
    }
    
    var url: URL? {
        return URL(string: self.replacingOccurrences(of: "ftp://ftp.pro-pharma.com.ua", with: "ftp://medbook_docflow:MbDf340674eee@ftp.pro-pharma.com.ua", options: .literal, range: nil))
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var clearTags: String {
        do {
            
            guard let data = self.data(using: .utf8, allowLossyConversion: true) else {
                throw StringError.dataCorrupted
            }
            
            let attributedString = try NSAttributedString(data: data,
                                                          options: [.documentType : NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                                                          documentAttributes: nil)
            
            return attributedString.string
            
        } catch {
            return self
                .replacingOccurrences(of: "<[^>]*>", with: "", options: .regularExpression, range: nil)
                .replacingOccurrences(of: "&quot;", with: "\"", options: .regularExpression, range: nil)
        }
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
}
func randomString(length: Int) -> String {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let len = UInt32(letters.length)
    
    var randomString = ""
    
    for _ in 0 ..< length {
        let rand = arc4random_uniform(len)
        var nextChar = letters.character(at: Int(rand))
        randomString += NSString(characters: &nextChar, length: 1) as String
    }
    
    return randomString
}
