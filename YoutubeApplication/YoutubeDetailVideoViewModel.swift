//
//  YoutubeDetailVideoViewModel.swift
//  YoutubeApplication
//
//  Created by wSong on 12/20/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation

class YoutubeDetailVideoViewModel {
    
    fileprivate var video: YoutubeVideoModel? {
        didSet {
            videoURL.value = video?.videoLinkURL
            videoTitle.value = video?.videoTitle
            thumbnailImage.value = video?.videoThumbnailImage
            videoNumberOfViews.value = video?.videoNumberOfViews
            videoDuration.value = video?.videoDuration
        }
    }
    //MARK:-Loading
    convenience init(videoItem: YoutubeVideoModel) {
        self.init()
        self.video = videoItem
    }
    
    var videoURL: Box<String?> {
        return Box(video?.videoLinkURL)
    }
    var videoTitle: Box<String?> {
        return Box(video?.videoTitle)
    }
    var thumbnailImage: Box<String?> {
        return Box(video?.videoThumbnailImage)
    }
    var videoNumberOfViews: Box<Int64?> {
        return Box(video?.videoNumberOfViews)
    }
    var videoDuration: Box<Int64?> {
        return Box(video?.videoDuration)
    }
}
