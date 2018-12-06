//
//  TimelineTrendingVideoServices.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/6/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import Foundation

protocol TimelineTrendingVideoServicesInput {
    func queryTrendingVideos() -> [YoutubeVideo]
    func updateTrendingVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> ())
}
class TimelineTrendingVideoServices: Handler, TimelineTrendingVideoServicesInput {
    
    private let provider = APIProvider<APITimeline>()
    
    public func updateTrendingVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> ()) {
        getTrendingVideos(onSuccess: { [weak self] (videos) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                onSuccess(videos)
            }
            strongSelf.saveTrendingVideos(videos)
        }) { (error) in
            print(error)
        }
    }
    
    public func queryTrendingVideos() -> [YoutubeVideo] {
        return AppStorage.getObject(ofType: [YoutubeVideo].self, forKey: "videos.trending", priority: .permanent) ?? []
    }
    
    private func saveTrendingVideos(_ videos: [YoutubeVideo]) {
        AppStorage.setObject(videos, forKey: "videos.trending", priority: .permanent)
    }
    
    private func getTrendingVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> (),
                                   onFailure: @escaping (_ error: String) -> ()) {
        self.provider.request(.trendingVideos) { (result) in
            self.handle(result: result, onSuccess: { (response) in
                if let youtubeModels = try? JSONDecoder().decode([YoutubeVideo].self, from: response.data) {
                    onSuccess(youtubeModels)
                }
            }, onError: { (error) in
                onFailure(error.localizedDescription)
            })
        }
    }
}
