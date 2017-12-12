//
//  YoutubeVideo.swift
//  YoutubeApplication
//
//  Created by wSong on 12/7/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit
import SwiftyJSON
protocol YoutubeVideoChannelItem {
    var channelName: String! {get set}
    var channelProfileImageLink: String! {get set}
}
struct YoutubeVideoChannel: YoutubeVideoChannelItem {
    var channelName: String!
    var channelProfileImageLink: String!
    init(response: JSON) {
        if let name = response["channel"]["name"].string {
            self.channelName = name
        }
        if let image = response["channel"]["profile_image_name"].string {
            self.channelProfileImageLink = image
        }else {
            self.channelProfileImageLink = ""
        }
    }
}
protocol YoutubeVideoItem {
    var channel: YoutubeVideoChannelItem? {get set}
    var videoTitle: String! {get set}
    var thumbnailImage: String! {get set}
    var videoLinkUrl: String! {get set}
    var videoNumberOfViews: Int! {get set}
    var videoDuration: Int! {get set}
}
struct YoutubeVideo: YoutubeVideoItem {
    var channel: YoutubeVideoChannelItem?
    var videoTitle: String!
    var thumbnailImage: String!
    var videoLinkUrl: String!
    var videoNumberOfViews: Int!
    var videoDuration: Int!
    init(response: JSON) {
        if let title = response["title"].string {
            self.videoTitle = title
        }
        if let image = response["thumbnail_image_name"].string {
            self.thumbnailImage = image
        }else {
            self.thumbnailImage = ""
        }
        if let numberOfViews = response["number_of_views"].int {
            self.videoNumberOfViews = numberOfViews
        }
        if let duration = response["duration"].int {
            self.videoDuration = duration
        }
    }
    init(response: JSON, channel: YoutubeVideoChannelItem) {
        self.init(response: response)
        self.channel = channel
    }
}











