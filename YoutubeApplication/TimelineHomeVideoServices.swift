//
//  TimelineServices.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/5/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import Foundation

protocol TimelineHomeVideoServicesInput {
    func queryHomeVideos() -> [YoutubeVideo]
    func updateHomeVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> ())
}
class TimelineHomeVideoServices: Handler, TimelineHomeVideoServicesInput {
    
    private let provider = APIProvider<APITimeline>()
    
    public func updateHomeVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> ()) {
        getHomeVideos(onSuccess: { [weak self] (videos) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                onSuccess(videos)
            }
            strongSelf.saveHomeVideos(videos)
        }) { (error) in
            print(error)
        }
    }
    
    public func queryHomeVideos() -> [YoutubeVideo] {
        return AppStorage.getObject(ofType: [YoutubeVideo].self, forKey: "videos.home", priority: .permanent) ?? []
    }
    
    private func saveHomeVideos(_ videos: [YoutubeVideo]) {
        AppStorage.setObject(videos, forKey: "videos.home", priority: .permanent)
    }
    
    private func getHomeVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> (),
                               onFailure: @escaping (_ error: String) -> ()) {
        self.provider.request(.homeVideos) { (result) in
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
