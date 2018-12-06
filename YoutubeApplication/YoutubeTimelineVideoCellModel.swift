//
//  YoutubeTimelineVideoCellModel.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/6/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YotubeTimelineVideoCellModel: BaseCellModel {
    
    override var cellIdentifier: String {
        return YoutubeTimelineVideoCollectionViewCell.reuseIdentifier
    }
    
    var videoTitle: String
    var thumbnailImage: String
    var videoLinkUrl: String
    var videoNumberOfViews: Int
    var videoDuration: Int
    var channel: YoutubeVideoChannel?
    
    init(video: YoutubeVideo) {
        self.videoTitle = video.videoTitle
        self.thumbnailImage = video.thumbnailImage
        self.videoLinkUrl = video.videoLinkUrl
        self.videoNumberOfViews = video.videoNumberOfViews
        self.videoDuration = video.videoDuration
        self.channel = video.channel
    }
}
