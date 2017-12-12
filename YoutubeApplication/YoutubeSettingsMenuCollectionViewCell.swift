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
    //MARK:-Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllConstraintsToViews()
        self.contentView.backgroundColor = UIColor.blue
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var settingsMenu: YoutubeSettingsMenuItem! {
        didSet {
            updateUI()
        }
    }
    private func updateUI() {
        DispatchQueue.main.async {
            self.menuImageView.image = UIImage(named: self.settingsMenu.settingsImageName)?.withRenderingMode(.alwaysTemplate)
            self.settingsTitleLabel.text = self.settingsMenu.settingsTitle
        }
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
    private func createmMenuImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = UIColor.white
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
        menuImageView.widthAnchor.constraint(equalToConstant: 22.0).isActive = true
        menuImageView.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
    }
    private func addConstraintsToTitleLabel() {
        settingsTitleLabel.leftAnchor.constraint(equalTo: menuImageView.leftAnchor, constant: 10.0).isActive = true
        settingsTitleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        settingsTitleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10.0).isActive = true
    }

}
