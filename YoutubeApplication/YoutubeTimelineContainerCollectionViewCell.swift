//
//  YoutubeTimelineContainerCollectionViewCell.swift
//  YoutubeApplication
//
//  Created by wSong on 12/15/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YoutubeTimelineContainerCollectionViewCell: IdentifiableCollectionViewCell {
    
    fileprivate var model: YotubeTimelineContainerVideoCellModel?
    fileprivate var cellOffset: CGFloat = 20.0
    fileprivate lazy var collectionView: UICollectionView = self.createCollectionView()
    fileprivate lazy var youtubeRefreshControl: YoutubeRefreshControl = self.createRefreshControl()
    
    //MARK:-Loading
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.collectionView.delegate = nil
        self.collectionView.dataSource = nil
        self.collectionView.reloadData()
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()
        self.collectionView.invalidateIntrinsicContentSize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupAllConstraintsToViews()
        self.collectionView.addSubview(youtubeRefreshControl)
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.cornerRadius = 14.0
        self.contentView.layer.masksToBounds = true
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
            self.collectionView.reloadData()
        }
        flowLayout.invalidateLayout()
    }
    //MARK:-CellModelRepresentable
    override func updateModel(_ model: CellIdentifiable?, viewModel: ViewModelCellPresentable?) {
        guard let model = model as? YotubeTimelineContainerVideoCellModel else { return }
        self.model = model
        
        collectionView.delegate = model
        collectionView.dataSource = model
        model.youtubeRefreshControl = youtubeRefreshControl
        
        defer {
            self.collectionView.reloadData()
            self.collectionView.setNeedsLayout()
            self.collectionView.layoutIfNeeded()
            self.collectionView.invalidateIntrinsicContentSize()
        }
    }
    //MARK:-Actions
    @objc func actionRefreshControlDidPull(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.youtubeRefreshControl.endRefreshing()
        }
    }
    //MARK:-CreateConstraints
    private func createCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.minimumLineSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let collection = UICollectionView(frame: self.frame, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(YoutubeTimelineVideoCollectionViewCell.self, forCellWithReuseIdentifier: YoutubeTimelineVideoCollectionViewCell.reuseIdentifier)
        collection.backgroundColor = UIColor.white
        collection.showsVerticalScrollIndicator = false
        addSubview(collection)
        return collection
    }
    
    private func createRefreshControl() -> YoutubeRefreshControl {
        let refreshControl = YoutubeRefreshControl()
        refreshControl.addTarget(self, action: #selector(actionRefreshControlDidPull(_:)), for: .valueChanged)
        return refreshControl
    }
    //MARK:-SetupConstraints
    private func setupAllConstraintsToViews() {
        setupConstraintsToCollectionView()
    }
    
    private func setupConstraintsToCollectionView() {
        collectionView.topAnchor.constraint(lessThanOrEqualTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
