//
//  YoutubeDataManager.swift
//  YoutubeApplication
//
//  Created by wSong on 12/8/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit
import CoreData

protocol YoutubeDataManagerInput {
    func fetchHomeVideosFromDataManager()
    func fetchTrendingVideosFromDataManager()
    func fetchSubscriptionsVideosFromDataManager()
    func fetchAccountVideosFromDataManager()
}
protocol YoutubeDataManagerOutput: class {
    func didHandleErrorFromFetchingRequest(_ error: String)
    func didHandleFetchRequestWith(_ videos: [YoutubeVideoModel])
}
class YoutubeDataManager: YoutubeDataManagerInput {
    
    fileprivate var container: NSPersistentContainer? = CoreDataManager.sharedInstance.persistentContainer
    
    weak var managerOutput: YoutubeDataManagerOutput?
    
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private let homeURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")!
    private let trendingURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/trending.json")!
    private let subscriptionsURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/subscriptions.json")!
    private let accountURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/account.json")!
    
    private func updateYoutubeVideoCoreDataModel(youtubeVideos: [YoutubeVideo]) {
        container?.performBackgroundTask({ [weak self] (context) in
            guard let strongSelf = self else { return }
            
            for videoInfo in youtubeVideos {
                let _ = try? YoutubeVideoModel.findOrCreateYoutubeVideo(matching: videoInfo, in: context)
            }
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
            strongSelf.printDatabaseStatistic()
        })
    }
    
    private func printDatabaseStatistic() {
        if let context = container?.viewContext { // viewContext is a main queue context
            context.perform { [weak self] in // Perfom means do this block, but what ever you do - do this in the right queue for this context
                guard let strongSelf = self else { return }
                let videoFetchRequest: NSFetchRequest<YoutubeVideoModel> = YoutubeVideoModel.fetchRequest()
                //can do predicate here to fetch unique videos
                if let videoModel = try? context.fetch(videoFetchRequest) {
                    strongSelf.managerOutput?.didHandleFetchRequestWith(videoModel)
                }
            }
        }
    }
    
    func fetchHomeVideosFromDataManager() {
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: homeURL, completionHandler: { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            defer { self?.dataTask = nil }
            if let error = error {
                DispatchQueue.main.async {
                    strongSelf.managerOutput?.didHandleErrorFromFetchingRequest(error.localizedDescription)
                }
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let youtubeModels = try? JSONDecoder().decode([YoutubeVideo].self, from: data) {
                    strongSelf.updateYoutubeVideoCoreDataModel(youtubeVideos: youtubeModels)
                }
            }
        })
        dataTask?.resume()
    }
    
    func fetchTrendingVideosFromDataManager() {
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: trendingURL, completionHandler: { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            defer { self?.dataTask = nil }
            if let error = error {
                DispatchQueue.main.async {
                    strongSelf.managerOutput?.didHandleErrorFromFetchingRequest(error.localizedDescription)
                }
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let youtubeModels = try? JSONDecoder().decode([YoutubeVideo].self, from: data) {
                    strongSelf.updateYoutubeVideoCoreDataModel(youtubeVideos: youtubeModels)
                }
            }
        })
        dataTask?.resume()
    }
    
    func fetchSubscriptionsVideosFromDataManager() {
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: subscriptionsURL, completionHandler: { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            defer { self?.dataTask = nil }
            if let error = error {
                DispatchQueue.main.async {
                    strongSelf.managerOutput?.didHandleErrorFromFetchingRequest(error.localizedDescription)
                }
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let youtubeModels = try? JSONDecoder().decode([YoutubeVideo].self, from: data) {
                    strongSelf.updateYoutubeVideoCoreDataModel(youtubeVideos: youtubeModels)
                }
            }
        })
        dataTask?.resume()
    }
    
    func fetchAccountVideosFromDataManager() {
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: accountURL, completionHandler: { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            defer { self?.dataTask = nil }
            if let error = error {
                DispatchQueue.main.async {
                    strongSelf.managerOutput?.didHandleErrorFromFetchingRequest(error.localizedDescription)
                }
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                if let youtubeModels = try? JSONDecoder().decode([YoutubeVideo].self, from: data) {
                    strongSelf.updateYoutubeVideoCoreDataModel(youtubeVideos: youtubeModels)
                }
            }
        })
        dataTask?.resume()
    }
}
