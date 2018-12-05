//
//  ViewModelCellPresentable.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 19.06.2018.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import Foundation

protocol ViewModelCellPresentable: class {
    func numberOfSections() -> Int
    func selectedItemAt(section: Int, atIndex: Int) -> CellIdentifiable
    func numberOfItemsInSection(section: Int) -> Int
    func headerForSection(section: Int) -> String
    func footerForSection(section: Int) -> String
    func removeItemAt(section: Int, atIndex: Int)
}
extension ViewModelCellPresentable {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func headerForSection(section: Int) -> String {
        return ""
    }
    
    func footerForSection(section: Int) -> String {
        return ""
    }
    
    func removeItemAt(section: Int, atIndex: Int) {
        
    }
}
