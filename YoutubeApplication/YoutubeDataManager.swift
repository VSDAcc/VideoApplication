//
//  YoutubeDataManager.swift
//  YoutubeApplication
//
//  Created by wSong on 12/8/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit
import SwiftyJSON

protocol YoutubeDataManagerOutput {
    func fetchHomeVideosFromDataManager()
    func fetchTrendingVideosFromDataManager()
    func fetchSubscriptionsVideosFromDataManager()
    func fetchAccountVideosFromDataManager()
}
protocol YoutubeDataManagerInput: class {
    func didFetchFeedVideosFromAPI(_ videos: [YoutubeVideoItem])
    func didHandleErrorFromFetchingRequest(_ error: String)
}
class YoutubeDataManager: YoutubeDataManagerOutput {
    
    weak var managerInput: YoutubeDataManagerInput?
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private var homeURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")!
    private var trendingURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/trending.json")!
    private var subscriptionsURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/subscriptions.json")!
    private var accountURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/account.json")!
    
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
                DispatchQueue.main.async {
                    self?.managerInput?.didFetchFeedVideosFromAPI(videoArray)
                }
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
                DispatchQueue.main.async {
                    self?.managerInput?.didFetchFeedVideosFromAPI(videoArray)
                }
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
                DispatchQueue.main.async {
                    self?.managerInput?.didFetchFeedVideosFromAPI(videoArray)
                }
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
                DispatchQueue.main.async {
                    self?.managerInput?.didFetchFeedVideosFromAPI(videoArray)
                }
            }
        })
        dataTask?.resume()
    }
}
