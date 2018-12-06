//
//  YoutubeVideo.swift
//  YoutubeApplication
//
//  Created by wSong on 12/7/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

struct YoutubeVideo {
    
    var videoTitle: String
    var thumbnailImage: String
    var videoLinkUrl: String
    var videoNumberOfViews: Int
    var videoDuration: Int
    var channel: YoutubeVideoChannel?
    
    init(videoTitle: String, thumbnailImage: String, videoLinkUrl: String, videoNumberOfViews: Int, videoDuration: Int, channel: YoutubeVideoChannel?) {
        self.videoTitle = videoTitle
        self.thumbnailImage = thumbnailImage
        self.videoLinkUrl = videoLinkUrl
        self.videoNumberOfViews = videoNumberOfViews
        self.videoDuration = videoDuration
        self.channel = channel
    }
}
extension YoutubeVideo: Codable {
    
    enum CodingKeys: String, CodingKey {
        case videoTitle = "title"
        case thumbnailImage = "thumbnail_image_name"
        case videoNumberOfViews = "number_of_views"
        case videoDuration = "duration"
        case channel = "channel"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let videoTitle: String = try container.decodeIfPresent(String.self, forKey: .videoTitle) ?? ""
        let thumbnailImage: String = try container.decodeIfPresent(String.self, forKey: .thumbnailImage) ?? ""
        let videoNumberOfViews: Int = try container.decodeIfPresent(Int.self, forKey: .videoNumberOfViews) ?? 0
        let videoDuration: Int = try container.decodeIfPresent(Int.self, forKey: .videoDuration) ?? 0
        let channel: YoutubeVideoChannel = try container.decodeIfPresent(YoutubeVideoChannel.self, forKey: .channel) ?? YoutubeVideoChannel(channelName: "", channelImageURL: "")
        
        let videoURL: String = "https://firebasestorage.googleapis.com/v0/b/photocardtest-bf9cd.appspot.com/o/Video_Storage%2FTestVideo.mov?alt=media&token=3ec6809a-b6c5-4f6e-a925-85d000588343"
        
        self.init(videoTitle: videoTitle, thumbnailImage: thumbnailImage, videoLinkUrl: videoURL, videoNumberOfViews: videoNumberOfViews, videoDuration: videoDuration, channel: channel)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(videoTitle, forKey: .videoTitle)
        try container.encode(thumbnailImage, forKey: .thumbnailImage)
        try container.encode(videoNumberOfViews, forKey: .videoNumberOfViews)
        try container.encode(videoDuration, forKey: .videoDuration)
        try container.encode(channel, forKey: .channel)
    }
}
struct YoutubeVideoChannel {
    
    let channelName: String
    let channelImageURL: String
    
    init(channelName: String, channelImageURL: String) {
        self.channelName = channelName
        self.channelImageURL = channelImageURL
    }
}
extension YoutubeVideoChannel: Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case profileImage = "profile_image_name"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name: String = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        let channelImage: String = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
        self.init(channelName: name, channelImageURL: channelImage)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(channelName, forKey: .name)
        try container.encode(channelImageURL, forKey: .profileImage)
    }
}
struct IphoneList {
    
    public let images: [String]
    public let title: String
    
    init(images: [String], title: String) {
        self.images = images
        self.title = title
    }
}
extension IphoneList: Codable {
    
    enum CodingKeys: String, CodingKey {
        case images = "images"
        case title = "title"
        case age
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let images: [String] = try container.decodeIfPresent([String].self, forKey: .images) ?? []
        let title: String = try container.decodeIfPresent(String.self, forKey: .title) ?? "empty"
        
        self.init(images: images, title: title)
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(images, forKey: .images)
        try container.encode(title, forKey: .title)
    }
}
