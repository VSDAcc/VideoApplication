//
//  YoutubeMenuBarView.swift
//  YoutubeApplication
//
//  Created by wSong on 12/11/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YoutubeMenuBarView: UIView {
    fileprivate struct CellID {
        static let youtubeMenuBarCellID = "youtubeMenuBarCell"
    }
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let collection = UICollectionView(frame: self.frame, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(YoutubeMenuBarCollectionViewCell.self, forCellWithReuseIdentifier: CellID.youtubeMenuBarCellID)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.clear
        collection.isScrollEnabled = false
        collection.selectItem(at: self.menuSelectedItem, animated: true, scrollPosition: .bottom)
        return collection
    }()
    private lazy var underlineView: UIView = self.createMenuBarUnderlineView()
    fileprivate var underlineViewLeadingConstraint: NSLayoutConstraint?
    weak var menuBarDidSelectItemAtInexPath: YoutubeMenuBarDidSelectItemAtInexPath?
    var menuSelectedItem: IndexPath = IndexPath(item: 0, section: 0) {
        didSet {
            actionPushUnderlineViewLeadingConstraint(item: menuSelectedItem.item)
            menuBarDidSelectItemAtInexPath?.didSelectYoutubeMenuItem(viewModel.selectedItemAt(indexPath: menuSelectedItem))
        }
    }
    fileprivate var collectionViewItemSizeToPortrait: CGSize {
        get {
            let width: CGFloat = (self.frame.width / 4)
            let height: CGFloat = self.frame.height
            return CGSize(width: width, height: height)
        }
    }
    fileprivate var collectionViewitemSizeToLandscape: CGSize {
        get {
            let width: CGFloat = (self.frame.width / 4)
            let height: CGFloat = self.frame.height
            return CGSize(width: width, height: height)
        }
    }
    var viewModel = YoutubeMenuBarViewModel()
    //MARK:-Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        addSubview(collectionView)
        addAllConstraintsToViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        DispatchQueue.main.async {
            self.actionPushUnderlineViewLeadingConstraint(item: self.menuSelectedItem.item)
        }
        flowLayout.invalidateLayout()
    }
    //MARK:-Actions
    fileprivate func actionPushUnderlineViewLeadingConstraint(item: Int) {
        let leading = CGFloat(item) * self.frame.width / 4.0
        self.underlineViewLeadingConstraint?.constant = leading
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.layoutIfNeeded()
        }, completion: { (finished) in })
    }
    //MARK:-SetupViews
    private func createMenuBarUnderlineView() -> UIView {
        let underline = UIView()
        underline.translatesAutoresizingMaskIntoConstraints = false
        underline.backgroundColor = UIColor.white
        underline.layer.cornerRadius = 2
        underline.layer.masksToBounds = true
        addSubview(underline)
        bringSubview(toFront: underline)
        return underline
    }
    //MARK:-SetupConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToCollectionView()
        addConstraintsToUnderlineView()
    }
    private func addConstraintsToCollectionView() {
        collectionView.centerXAnchor.constraint(lessThanOrEqualTo: self.centerXAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    private func addConstraintsToUnderlineView() {
        underlineViewLeadingConstraint = underlineView.leftAnchor.constraint(lessThanOrEqualTo: self.leftAnchor)
        underlineViewLeadingConstraint?.isActive = true
        underlineView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        underlineView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/4).isActive = true
        underlineView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
}
extension YoutubeMenuBarView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numerOfItemsInSection(section: section)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let timelineCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.youtubeMenuBarCellID, for: indexPath) as! YoutubeMenuBarCollectionViewCell
        let menuBar = viewModel.selectedItemAt(indexPath: indexPath)
        timelineCell.menuBar = menuBar
        timelineCell.layoutIfNeeded()
        return timelineCell
    }
}
extension YoutubeMenuBarView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menuSelectedItem = indexPath
        menuBarDidSelectItemAtInexPath?.didSelectMenuBarItemAtIndexPath(indexPath)
    }
}
extension YoutubeMenuBarView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            return collectionViewitemSizeToLandscape
        }else {
            return collectionViewItemSizeToPortrait
        }
    }
}

