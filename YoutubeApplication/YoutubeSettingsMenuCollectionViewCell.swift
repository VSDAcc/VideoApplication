//
//  YoutubeSettingsMenuCollectionViewCell.swift
//  YoutubeApplication
//
//  Created by wSong on 12/11/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YoutubeSettingsMenuCollectionViewCell: UICollectionViewCell {
    lazy var settingsTitleLabel: UILabel = self.createTitleLabel()
    lazy var menuImageView: UIImageView = self.createmMenuImageView()
    private var unhiglitedTextColor: UIColor {
        return UIColor.black
    }
    private var unhiglitedImageColor: UIColor {
        return UIColor.darkGray
    }
    //MARK:-Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllConstraintsToViews()
        self.contentView.backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 16.0
        self.layer.masksToBounds = true
    }
    override var isHighlighted: Bool {
        didSet {
            DispatchQueue.main.async {
                self.menuImageView.tintColor = self.isHighlighted ? UIColor.white : self.unhiglitedImageColor
                self.settingsTitleLabel.textColor = self.isHighlighted ? UIColor.white : self.unhiglitedTextColor
                self.contentView.backgroundColor = self.isHighlighted ? UIColor.red : UIColor.clear
            }
        }
    }
    var settingsMenu: YoutubeSettingsMenuItem! {
        didSet {
            updateUI()
        }
    }
    private func updateUI() {
        DispatchQueue.main.async {
            self.menuImageView.image = UIImage(named: self.settingsMenu.settingsImageName.description)?.withRenderingMode(.alwaysTemplate)
            self.settingsTitleLabel.text = self.settingsMenu.settingsTitle.description
        }
    }
    //MAKR:-SetupViews
    private func createTitleLabel() -> UILabel {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textAlignment = .left
        nameLabel.font = UIFont().avenirNextRegularTitleFont
        nameLabel.numberOfLines = 1
        nameLabel.textColor = self.unhiglitedTextColor
        addSubview(nameLabel)
        return nameLabel
    }
    private func createmMenuImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = self.unhiglitedImageColor
        addSubview(imageView)
        return imageView
    }
    //MARK:-AddConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToMenuImageView()
        addConstraintsToTitleLabel()
    }
    private func addConstraintsToMenuImageView() {
        menuImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10.0).isActive = true
        menuImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        menuImageView.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
        menuImageView.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
    }
    private func addConstraintsToTitleLabel() {
        settingsTitleLabel.leftAnchor.constraint(equalTo: menuImageView.rightAnchor, constant: 10.0).isActive = true
        settingsTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        settingsTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0).isActive = true
    }
}











