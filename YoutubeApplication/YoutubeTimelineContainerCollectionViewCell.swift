//
//  YoutubeTimelineContainerCollectionViewCell.swift
//  YoutubeApplication
//
//  Created by wSong on 12/15/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit
protocol YoutubeTimelineViewControllerInput: class {
    func didFinishUpdates()
    func didHandleError(_ error: String)
}
class YoutubeTimelineContainerCollectionViewCell: UICollectionViewCell, YoutubeTimelineViewControllerInput {
    fileprivate struct CellID {
        static let youtubeTimelineCellID = "youtubeTimelineCell"
    }
    fileprivate var cellOffset: CGFloat = 20.0
    fileprivate var collectionViewItemSizeToPortrait: CGSize {
        get {
            let width: CGFloat = self.frame.width - cellOffset
            let height: CGFloat = (width / 1.15)
            return CGSize(width: width, height: height)
        }
    }
    fileprivate var collectionViewitemSizeToLandscape: CGSize {
        get {
            let width: CGFloat = ((self.frame.width / 2) - (cellOffset * 2))
            let height: CGFloat = (width / 1.5) * (4 / 3)
            return CGSize(width: width, height: height)
        }
    }
    lazy var collectionView: UICollectionView = self.createCollectionView()
    var viewModel = YoutubeTimelineViewModel()
    //MARK:-Loading
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAllConstraintsToViews()
        self.contentView.backgroundColor = UIColor.clear
        viewModel.view = self
        fetchVideosFromDataManager()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    func fetchVideosFromDataManager() { }
    //MARK:-YoutubeTimelineViewControllerInput
    func didFinishUpdates() {
        collectionView.reloadData()
    }
    func didHandleError(_ error: String) {
        //presentAlertWith(title: "Data Error", massage: error)
    }
    //MARK:-CreateConstraints
    private func createCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collection = UICollectionView(frame: self.frame, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(YoutubeTimelineCollectionViewCell.self, forCellWithReuseIdentifier: CellID.youtubeTimelineCellID)
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = UIColor.white
        addSubview(collection)
        return collection
    }
    //MARK:-SetupConstraints
    private func addAllConstraintsToViews() {
        addConstraintsToCollectionView()
    }
    private func addConstraintsToCollectionView() {
        collectionView.leftAnchor.constraint(lessThanOrEqualTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
extension YoutubeTimelineContainerCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numerOfItemsInSection(section: section)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let timelineCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.youtubeTimelineCellID, for: indexPath) as! YoutubeTimelineCollectionViewCell
        let video = viewModel.selectedItemAt(indexPath: indexPath)
        timelineCell.youtubeVideo = video
        timelineCell.layoutIfNeeded()
        return timelineCell
    }
}
extension YoutubeTimelineContainerCollectionViewCell: UICollectionViewDelegate {
}
extension YoutubeTimelineContainerCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            return collectionViewitemSizeToLandscape
        }else {
            return collectionViewItemSizeToPortrait
        }
    }
}



