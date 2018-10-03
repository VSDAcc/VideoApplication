//
//  YoutubeNavigationBarTitleView.swift
//  YoutubeApplication
//
//  Created by wSong on 12/6/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YoutubeNavigationBarTitleView: UIView {
    lazy var titleLabel: UILabel = self.createTitleLabel()
    
    //MARK:-Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllConstraintsToViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    //MAKR:-SetupViews
    private func createTitleLabel() -> UILabel {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont().avenirNextRegularTitleFont
        nameLabel.numberOfLines = 1
        nameLabel.textColor = UIColor.white
        addSubview(nameLabel)
        return nameLabel
    }
    //MARK:-AddConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToTitleLabel()
    }
    
    private func addConstraintsToTitleLabel() {
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
