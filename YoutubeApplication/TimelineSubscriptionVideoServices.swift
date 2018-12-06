//
//  TimelineSubscriptionVideoServices.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/6/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import Foundation

protocol TimelineSubscriptionVideoServicesInput {
    func querySubscriptionVideos() -> [YoutubeVideo]
    func updateSubscriptionVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> ())
}
class TimelineSubscriptionVideoServices: Handler, TimelineSubscriptionVideoServicesInput {
    
    private let provider = APIProvider<APITimeline>()
    
    public func updateSubscriptionVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> ()) {
        getSubscriptionVideos(onSuccess: { [weak self] (videos) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                onSuccess(videos)
            }
            strongSelf.saveSubscriptionVideos(videos)
        }) { (error) in
            print(error)
        }
    }
    
    public func querySubscriptionVideos() -> [YoutubeVideo] {
        return AppStorage.getObject(ofType: [YoutubeVideo].self, forKey: "videos.subscription", priority: .permanent) ?? []
    }
    
    private func saveSubscriptionVideos(_ videos: [YoutubeVideo]) {
        AppStorage.setObject(videos, forKey: "videos.subscription", priority: .permanent)
    }
    
    private func getSubscriptionVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> (),
                                       onFailure: @escaping (_ error: String) -> ()) {
        self.provider.request(.subscriptionVideos) { (result) in
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
