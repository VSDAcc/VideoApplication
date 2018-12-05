//
//  CellModelRepresentable.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 19.06.2018.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import UIKit

protocol CellModelRepresentable {
    func updateModel(_ model: CellIdentifiable?, viewModel: ViewModelCellPresentable?)
}
