//
//  SectionRowsRepresentable.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 19.06.2018.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import Foundation

protocol SectionRowsRepresentable: class {
    var headerTitle: String {get set}
    var footerTitle: String {get set}
    var rows: [CellIdentifiable] {get set}
}
class BaseSectionModel: SectionRowsRepresentable {
    
    var rows: [CellIdentifiable]
    var headerTitle: String = ""
    var footerTitle: String = ""
    
    init() {
        rows = [CellIdentifiable]()
    }
}
