//
//  CellIdentifiable.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 19.06.2018.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import Foundation

protocol CellIdentifiable {
    var cellIdentifier: String { get }
}
class BaseCellModel: NSObject, CellIdentifiable {
    
    var cellIdentifier: String {
        return ""
    }
    
    static func == (lhs: BaseCellModel, rhs: BaseCellModel) -> Bool {
        return lhs.cellIdentifier == rhs.cellIdentifier
    }
}
