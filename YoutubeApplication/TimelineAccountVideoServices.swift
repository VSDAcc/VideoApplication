//
//  TimelineAccountVideoServices.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/6/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import Foundation

protocol TimelineAccountVideoServicesInput {
    func queryAccountVideos() -> [YoutubeVideo]
    func updateAccountVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> ())
}
class TimelineAccountVideoServices: Handler, TimelineAccountVideoServicesInput {
    
    private let provider = APIProvider<APITimeline>()
    
    public func updateAccountVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> ()) {
        getAccountVideos(onSuccess: { [weak self] (videos) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                onSuccess(videos)
            }
            strongSelf.saveAccountVideos(videos)
        }) { (error) in
            print(error)
        }
    }
    
    public func queryAccountVideos() -> [YoutubeVideo] {
        return AppStorage.getObject(ofType: [YoutubeVideo].self, forKey: "videos.account", priority: .permanent) ?? []
    }
    
    private func saveAccountVideos(_ videos: [YoutubeVideo]) {
        AppStorage.setObject(videos, forKey: "videos.account", priority: .permanent)
    }
    
    private func getAccountVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> (),
                                  onFailure: @escaping (_ error: String) -> ()) {
        self.provider.request(.accountVideos) { (result) in
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
