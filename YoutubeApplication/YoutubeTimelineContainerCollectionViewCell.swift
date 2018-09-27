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
            let width: CGFloat = self.frame.width / 2.2
            let height: CGFloat = (width / 1.5) * (4 / 3)
            return CGSize(width: width, height: height)
        }
    }
    lazy var collectionView: UICollectionView = self.createCollectionView()
    var viewModel = YoutubeTimelineViewModel()
    weak var youtubeTimelineContainerViewCellHandler: YoutubeTimelineContainerViewCellHandler?
    fileprivate var youtubeRefreshControl: YoutubeRefreshControl!
    
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
        configureRefreshControl()
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
    //MARK:-ConfigureMethods
    fileprivate func configureRefreshControl() {
        let refreshControl = YoutubeRefreshControl()
        refreshControl.addTarget(self, action: #selector(actionRefreshControlDidPull(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        youtubeRefreshControl = refreshControl
    }
    //MARK:-Actions
    @objc func actionRefreshControlDidPull(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.youtubeRefreshControl.endRefreshing()
        }
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
        collection.showsVerticalScrollIndicator = false
        addSubview(collection)
        return collection
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
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = viewModel.selectedItemAt(indexPath: indexPath)
        let selectedCell = collectionView.cellForItem(at: indexPath) as! YoutubeTimelineCollectionViewCell
        youtubeTimelineContainerViewCellHandler?.didSelectTimelineYoutubeVideoItem(video, selectedCell)
    }
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
extension YoutubeTimelineContainerCollectionViewCell: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        youtubeRefreshControl.containingScrollViewDidScroll(scrollView: scrollView)
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        youtubeRefreshControl.containingScrollViewDidEndDragging(scrollView: scrollView, willDecelerate: decelerate)
    }
}


















