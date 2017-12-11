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
    func fetchFeedVideosFromAPI()
}
protocol YoutubeDataManagerInput: class {
    func didFetchFeedVideosFromAPI(_ videos: [YoutubeVideoItem])
    func didHandleErrorFromFetchingRequest(_ error: String)
}
class YoutubeDataManager: YoutubeDataManagerOutput {
    weak var managerInput: YoutubeDataManagerInput?
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask?
    private var feedURL: URL = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")!
    
    func fetchFeedVideosFromAPI() {
        dataTask?.cancel()
        dataTask = defaultSession.dataTask(with: feedURL, completionHandler: { [weak self] (data, response, error) in
            defer { self?.dataTask = nil }
            if let error = error {
                DispatchQueue.main.async {
                    self?.managerInput?.didHandleErrorFromFetchingRequest(error.localizedDescription)
                }
            }else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                let jsonObject = JSON(data).arrayValue
                var videoArray = [YoutubeVideoItem]()
                for value in jsonObject {
                    let videos = YoutubeVideo(response: value, channel: YoutubeVideoChannel(response: value))
                    videoArray.append(videos)
                }
                DispatchQueue.main.async {
                    self?.managerInput?.didFetchFeedVideosFromAPI(videoArray)
                }
            }
        })
        dataTask?.resume()
    }
}
