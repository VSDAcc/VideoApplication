//
//  TimelineAccountVideoServices.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/6/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import Foundation

protocol TimelineVideoServicesDelegate {
    func queryVideos(with target: APITimeline) -> [YoutubeVideo]
    func updateVideos(with target: APITimeline,
                      onSuccess: @escaping (_ models: [YoutubeVideo]) -> ())
}
class TimelineVideoServices: Handler, TimelineVideoServicesDelegate {
    
    private let semaphore = DispatchSemaphore(value: 1)
    private let provider = APIProvider<APITimeline>()
    
    public func updateVideos(with target: APITimeline,
                             onSuccess: @escaping (_ models: [YoutubeVideo]) -> ()) {
        getVideos(with: target, onSuccess: { [weak self] (videos) in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                onSuccess(videos)
            }
            strongSelf.semaphore.wait()
            strongSelf.saveVideos(with: target, videos: videos)
            strongSelf.semaphore.signal()
        }) { (error) in
            print(error)
        }
    }
    
    public func queryVideos(with target: APITimeline) -> [YoutubeVideo] {
        return AppStorage.getObject(ofType: [YoutubeVideo].self, forKey: target.description, priority: .permanent) ?? []
    }
    
    private func saveVideos(with target: APITimeline, videos: [YoutubeVideo]) {
        AppStorage.setObject(videos, forKey: target.description, priority: .permanent)
    }
    
    private func getVideos(with target: APITimeline,
                           onSuccess: @escaping (_ models: [YoutubeVideo]) -> (),
                           onFailure: @escaping (_ error: String) -> ()) {
        self.provider.request(target) { (result) in
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
