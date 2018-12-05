//
//  Reusable.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 11/25/18.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import UIKit

protocol Reusable {
    
    static var reuseIdentifier: String { get }
}

extension Reusable {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
extension UITableViewCell: Reusable { }
extension UICollectionReusableView: Reusable { }

