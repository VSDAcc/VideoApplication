//
//  VideoService.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 2/25/19.
//  Copyright © 2019 VladymyrShorokhov. All rights reserved.
//

import Foundation

protocol TimelineVideoServicesStrategy {
    func queryVideos(with target: APITimeline) -> [YoutubeVideo]
    func updateVideos(with target: APITimeline,
                      onSuccess: @escaping (_ models: [YoutubeVideo]) -> ())
}
class TimelineVideoService: TimelineVideoServicesStrategy {
    
    public var service: TimelineVideoServicesStrategy
    
    init(service: TimelineVideoServicesStrategy) {
        self.service = service
    }
    
    func updateVideos(with target: APITimeline, onSuccess: @escaping ([YoutubeVideo]) -> ()) {
        service.updateVideos(with: target, onSuccess: onSuccess)
    }
    
    func queryVideos(with target: APITimeline) -> [YoutubeVideo] {
        return service.queryVideos(with: target)
    }
}
