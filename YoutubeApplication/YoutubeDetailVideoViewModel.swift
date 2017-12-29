//
//  YoutubeDetailVideoViewModel.swift
//  YoutubeApplication
//
//  Created by wSong on 12/20/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation
class YoutubeDetailVideoViewModel {
    fileprivate var video: YoutubeVideoItem? {
        didSet {
            videoURL.value = video?.videoLinkUrl
            videoTitle.value = video?.videoTitle
            thumbnailImage.value = video?.thumbnailImage
            videoNumberOfViews.value = video?.videoNumberOfViews
            videoDuration.value = video?.videoDuration
        }
    }
    convenience init(videoItem: YoutubeVideoItem) {
        self.init()
        self.video = videoItem
    }
    var videoURL: Box<String?> {
        return Box(video?.videoLinkUrl)
    }
    var videoTitle: Box<String?> {
        return Box(video?.videoTitle)
    }
    var thumbnailImage: Box<String?> {
        return Box(video?.thumbnailImage)
    }
    var videoNumberOfViews: Box<Int?> {
        return Box(video?.videoNumberOfViews)
    }
    var videoDuration: Box<Int?> {
        return Box(video?.videoDuration)
    }
}
