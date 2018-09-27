//
//  YoutubeMenuBarCollectionViewCell.swift
//  YoutubeApplication
//
//  Created by wSong on 12/6/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YoutubeMenuBarCollectionViewCell: UICollectionViewCell {
    
    lazy var menuImageView: UIImageView = self.createmMenuImageView()
    private var unhiglitedColor: UIColor {
        return UIColor(r: 91, g: 14, b: 13, alpha: 1)
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
    }
    override var isHighlighted: Bool {
        didSet {
            DispatchQueue.main.async {
                self.menuImageView.tintColor = self.isHighlighted ? UIColor.white : self.unhiglitedColor
            }
        }
    }
    override var isSelected: Bool {
        didSet {
            DispatchQueue.main.async {
                self.menuImageView.tintColor = self.isSelected ? UIColor.white : self.unhiglitedColor
            }
        }
    }
    var menuBar: YoutubeMenuBarItem! {
        didSet {
            updateUI()
        }
    }
    private func updateUI() {
        DispatchQueue.main.async {
            self.menuImageView.image = UIImage(named: self.menuBar.itemImageName.description)?.withRenderingMode(.alwaysTemplate)
        }
    }
    //MARK:-SetupViews
    private func createmMenuImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = unhiglitedColor
        addSubview(imageView)
        return imageView
    }
    //MARK:-SetupConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToMenuImageView()
    }
    private func addConstraintsToMenuImageView() {
        menuImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        menuImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        menuImageView.widthAnchor.constraint(equalToConstant: 28.0).isActive = true
        menuImageView.heightAnchor.constraint(equalToConstant: 28.0).isActive = true
    }
}
