//
//  Cell.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 11/30/18.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import UIKit

extension UITableViewCell {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
}

extension UICollectionViewCell {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.prepareForReuse()
    }
}
