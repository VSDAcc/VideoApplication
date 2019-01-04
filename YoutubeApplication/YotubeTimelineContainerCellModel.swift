//
//  YotubeTimelineCellModel.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/6/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit

protocol YotubeTimelineContainerVideoCellHandler: class {
    func didSelectVideoModel(_ model: YotubeTimelineVideoCellModel, cell: YoutubeTimelineVideoCollectionViewCell)
}

class YotubeTimelineContainerVideoCellModel: BaseCellModel, ViewModelCellPresentable {

    override var cellIdentifier: String {
        return YoutubeTimelineContainerCollectionViewCell.reuseIdentifier
    }

    public var youtubeRefreshControl: YoutubeRefreshControl?
    
    public weak var delegate: YotubeTimelineContainerVideoCellHandler?

    fileprivate let cellOffset: CGFloat = 20.0
    fileprivate var sections = [SectionRowsRepresentable]()
    fileprivate var youtubeTimelineVideoSectionModel = YoutubeTimelineVideoSectionModel()

    func loadData(_ videos: [YoutubeVideo]) {
        self.sections = [youtubeTimelineVideoSectionModel]
        self.youtubeTimelineVideoSectionModel.updateVideoSectionModel(videos)
    }

    fileprivate func didSelectModel(_ model: CellIdentifiable, cell: YoutubeTimelineVideoCollectionViewCell) {
        if let videoModel = model as? YotubeTimelineVideoCellModel {
            delegate?.didSelectVideoModel(videoModel, cell: cell)
        }
    }
}
extension YotubeTimelineContainerVideoCellModel {

    func numberOfSections() -> Int {
        return sections.count
    }

    func selectedItemAt(section: Int, atIndex: Int) -> CellIdentifiable {
        return sections[section].rows[atIndex]
    }

    func numberOfItemsInSection(section: Int) -> Int {
        return sections[section].rows.count
    }
}
extension YotubeTimelineContainerVideoCellModel: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItemsInSection(section: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let videoCellModel = selectedItemAt(section: indexPath.section, atIndex: indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellModel.cellIdentifier, for: indexPath) as! IdentifiableCollectionViewCell
        cell.updateModel(videoCellModel, viewModel: self)
        return cell
    }
}
extension YotubeTimelineContainerVideoCellModel: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        let videoCellModel = selectedItemAt(section: indexPath.section, atIndex: indexPath.row)
        let selectedCell = collectionView.cellForItem(at: indexPath) as! YoutubeTimelineVideoCollectionViewCell
        didSelectModel(videoCellModel, cell: selectedCell)
    }
}
extension YotubeTimelineContainerVideoCellModel: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            let width: CGFloat = (collectionView.bounds.width / 2) - cellOffset
            let height: CGFloat = (width / 1.5) * (4 / 3)
            let size = CGSize(width: width, height: height)
            return size
        } else {
            let width: CGFloat = collectionView.bounds.width - cellOffset
            let height: CGFloat = (width / 1.15)
            let size = CGSize(width: width, height: height)
            return size
        }
    }
}
extension YotubeTimelineContainerVideoCellModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        youtubeRefreshControl?.containingScrollViewDidScroll(scrollView: scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        youtubeRefreshControl?.containingScrollViewDidEndDragging(scrollView: scrollView, willDecelerate: decelerate)
    }
}
