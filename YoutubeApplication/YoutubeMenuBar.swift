//
//  YoutubeMenuBar.swift
//  YoutubeApplication
//
//  Created by wSong on 12/6/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YoutubeMenuBar: UIView {
    fileprivate struct CellID {
        static let youtubeMenuBarCellID = "youtubeMenuBarCell"
    }
    var viewModel = YoutubeMenuBarViewModel()
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
        return collection
    }()
    //MARK:-Loading
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.red
        addSubview(collectionView)
        addAllConstraintsToViews()
        homeSelectedItem()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func homeSelectedItem() {
        let selectedItem = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedItem, animated: true, scrollPosition: .bottom)
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
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    //MARK:-SetupConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToCollectionView()
    }
    private func addConstraintsToCollectionView() {
        collectionView.centerXAnchor.constraint(lessThanOrEqualTo: self.centerXAnchor).isActive = true
        collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
}
extension YoutubeMenuBar: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numerOfItemsInSection(section: section)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let timelineCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.youtubeMenuBarCellID, for: indexPath) as! YoutubeMenuBarCollectionViewCell
        timelineCell.menuImageView.image = UIImage(named: viewModel.selectedItemAt(indexPath: indexPath))?.withRenderingMode(.alwaysTemplate)
        timelineCell.layoutIfNeeded()
        return timelineCell
    }
}
extension YoutubeMenuBar: UICollectionViewDelegate {
}
extension YoutubeMenuBar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            return collectionViewitemSizeToLandscape
        }else {
            return collectionViewItemSizeToPortrait
        }
    }
}











