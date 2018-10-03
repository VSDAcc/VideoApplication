//
//  YoutubeDataManager.swift
//  YoutubeApplication
//
//  Created by wSong on 12/8/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

protocol YoutubeDataManagerOutput {
    func fetchHomeVideosFromDataManager()
    func fetchTrendingVideosFromDataManager()
    func fetchSubscriptionsVideosFromDataManager()
    func fetchAccountVideosFromDataManager()
}
protocol YoutubeDataManagerInput: class {
    func didHandleErrorFromFetchingRequest(_ error: String)
    func didHandleFetchRequestWith(_ videos: [YoutubeVideoModel])
}
class YoutubeDataManager: YoutubeDataManagerOutput {
    
    var container: NSPersistentContainer? = CoreDataManager.sharedInstance.persistentContainer
    weak var managerInput: YoutubeDataManagerInput?
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private let homeURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")!
    private let trendingURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/trending.json")!
    private let subscriptionsURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/subscriptions.json")!
    private let accountURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/account.json")!
    
    private func updateYoutubeVideoCoreDataModel(youtubeVideos: [YoutubeVideoItem]) {
        container?.performBackgroundTask({ [weak self] (context) in
            for videoInfo in youtubeVideos {
               let _ = try? YoutubeVideoModel.findOrCreateYoutubeVideo(matching: videoInfo, in: context)
            }
            try? context.save()
            self?.printDatabaseStatistic()
        })
    }
    
    private func printDatabaseStatistic() {
        if let context = container?.viewContext { // should be main thread
            context.perform { [weak self] in // safe main thread
                let videoFetchRequest: NSFetchRequest<YoutubeVideoModel> = YoutubeVideoModel.fetchRequest()
                if let videoModel = try? context.fetch(videoFetchRequest) {
                    self?.managerInput?.didHandleFetchRequestWith(videoModel)
                }
            }
        }
    }
    
    func fetchHomeVideosFromDataManager() {
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: homeURL, completionHandler: { [weak self] (data, response, error) in
            defer { self?.dataTask = nil }
            if let error = error {
                DispatchQueue.main.async {
                    self?.managerInput?.didHandleErrorFromFetchingRequest(error.localizedDescription)
                }
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let jsonObject = JSON(data).arrayValue
                let videoArray = jsonObject.map({
                    return YoutubeVideo(response: $0, channel: YoutubeVideoChannel(response: $0))
                })
                self?.updateYoutubeVideoCoreDataModel(youtubeVideos: videoArray)
            }
        })
        dataTask?.resume()
    }
    
    func fetchTrendingVideosFromDataManager() {
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: trendingURL, completionHandler: { [weak self] (data, response, error) in
            defer { self?.dataTask = nil }
            if let error = error {
                DispatchQueue.main.async {
                    self?.managerInput?.didHandleErrorFromFetchingRequest(error.localizedDescription)
                }
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let jsonObject = JSON(data).arrayValue
                let videoArray = jsonObject.map({
                    return YoutubeVideo(response: $0, channel: YoutubeVideoChannel(response: $0))
                })
                self?.updateYoutubeVideoCoreDataModel(youtubeVideos: videoArray)
            }
        })
        dataTask?.resume()
    }
    
    func fetchSubscriptionsVideosFromDataManager() {
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: subscriptionsURL, completionHandler: { [weak self] (data, response, error) in
            defer { self?.dataTask = nil }
            if let error = error {
                DispatchQueue.main.async {
                    self?.managerInput?.didHandleErrorFromFetchingRequest(error.localizedDescription)
                }
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let jsonObject = JSON(data).arrayValue
                let videoArray = jsonObject.map({
                    return YoutubeVideo(response: $0, channel: YoutubeVideoChannel(response: $0))
                })
                self?.updateYoutubeVideoCoreDataModel(youtubeVideos: videoArray)
            }
        })
        dataTask?.resume()
    }
    
    func fetchAccountVideosFromDataManager() {
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: accountURL, completionHandler: { [weak self] (data, response, error) in
            defer { self?.dataTask = nil }
            if let error = error {
                DispatchQueue.main.async {
                    self?.managerInput?.didHandleErrorFromFetchingRequest(error.localizedDescription)
                }
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let jsonObject = JSON(data).arrayValue
                let videoArray = jsonObject.map({
                    return YoutubeVideo(response: $0, channel: YoutubeVideoChannel(response: $0))
                })
                self?.updateYoutubeVideoCoreDataModel(youtubeVideos: videoArray)
            }
        })
        dataTask?.resume()
    }
}
