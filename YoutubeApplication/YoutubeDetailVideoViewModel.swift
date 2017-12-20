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
        }
    }
    convenience init(videoItem: YoutubeVideoItem) {
        self.init()
        self.video = videoItem
    }
    var videoURL: Box<String?> {
        return Box(video?.videoLinkUrl)
    }
}
