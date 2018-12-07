//
//  YoutubeDetailVideoViewModel.swift
//  YoutubeApplication
//
//  Created by wSong on 12/20/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation

protocol YoutubeDetailVideoViewModelCoordinatorDelegate: class {
    func backToYoutubeTimelineViewController(animated: Bool)
}
protocol YoutubeDetailVideoViewModelInput: class {
    var videoURL: Box<String?> { get }
    var videoTitle: Box<String?> { get }
    var thumbnailImage: Box<String?> { get }
    var videoNumberOfViews: Box<Int?> { get }
    var videoDuration: Box<Int?>{ get }
    var coordinator: YoutubeDetailVideoViewModelCoordinatorDelegate? {get set}
}
class YoutubeDetailVideoViewModel: YoutubeDetailVideoViewModelInput {
    
    weak var coordinator: YoutubeDetailVideoViewModelCoordinatorDelegate?
    
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
    
    fileprivate var video: YoutubeVideo? {
        didSet {
            videoURL.value = video?.videoLinkUrl
            videoTitle.value = video?.videoTitle
            thumbnailImage.value = video?.thumbnailImage
            videoNumberOfViews.value = video?.videoNumberOfViews
            videoDuration.value = video?.videoDuration
        }
    }
    //MARK:-Loading
    convenience init(videoItem: YoutubeVideo) {
        self.init()
        self.video = videoItem
    }
}
