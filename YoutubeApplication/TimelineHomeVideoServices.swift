//
//  TimelineServices.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/5/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import Foundation
import CoreData

protocol TimelineHomeVideoServicesInput {

}
class TimelineHomeVideoServices: Handler, TimelineHomeVideoServicesInput {
    
    private let provider = APIProvider<APITimeline>()
    private var container: NSPersistentContainer? = CoreDataManager.sharedInstance.persistentContainer

    private func getHomeVideos(onSuccess: @escaping (_ models: [YoutubeVideo]) -> (),
                               onFailure: @escaping (_ error: String) -> ()) {
        self.provider.request(.homeVideos) { (result) in
            self.handle(result: result, onSuccess: { (response) in
                if let youtubeModels = try? JSONDecoder().decode([YoutubeVideo].self, from: response.data) {
                    onSuccess(youtubeModels)
                } else {
                    onFailure("Network connection error")
                }
            }, onError: { (error) in
                onFailure(error.localizedDescription)
            })
        }
    }
}
