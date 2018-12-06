//
//  YoutubeTimelineSectionModel.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/6/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import Foundation

protocol YoutubeTimelineVideoSectionModelHandler: YotubeTimelineContainerVideoCellHandler {
    
}
class YoutubeTimelineVideoContainerSectionModel: BaseSectionModel {
    
    public weak var delegate: YoutubeTimelineVideoSectionModelHandler?
    
    public func updateVideoSectionModel(_ videos: [YoutubeVideo]) {
        var tempRows: [CellIdentifiable] = []
        if !videos.isEmpty {
            let containerCellModel = YotubeTimelineContainerVideoCellModel()
            containerCellModel.delegate = delegate
            containerCellModel.loadData(videos)
            tempRows = [containerCellModel]
        } else {
            let emptyVideos = [YoutubeVideo(videoTitle: "Nothing here", thumbnailImage: "", videoLinkUrl: "", videoNumberOfViews: 0, videoDuration: 0, channel: nil)]
            let containerCellModel = YotubeTimelineContainerVideoCellModel()
            containerCellModel.delegate = delegate
            containerCellModel.loadData(emptyVideos)
            tempRows = [containerCellModel]
        }
        rows = tempRows
    }
}
class YoutubeTimelineVideoSectionModel: BaseSectionModel {
    
    public func updateVideoSectionModel(_ videos: [YoutubeVideo]) {
        var tempRows: [CellIdentifiable] = []
        videos.forEach { (video) in
            let cellModel = YotubeTimelineVideoCellModel(video: video)
            tempRows.append(cellModel)
        }
        rows = tempRows
    }
}
