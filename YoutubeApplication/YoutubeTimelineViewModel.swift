//
//  YoutubeTimelineViewModel.swift
//  YoutubeApplication
//
//  Created by wSong on 12/5/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation
protocol YoutubeViewModelOutput: YoutubeDataManagerInput {
    func queryHomeVideosFromDataManager()
    func queryTrendingVideosFromDataManager()
    func querySubscriptionsVideosFromDataManager()
    func queryAccountVideosFromDataManager()
}
class YoutubeTimelineViewModel: YoutubeViewModelOutput {
    fileprivate var videos = [YoutubeVideoItem]()
    var dataManager = YoutubeDataManager()
    weak var view: YoutubeTimelineViewControllerInput?
    init() {
        dataManager.managerInput = self
    }
    //MARK:-YoutubeViewModelOutput
    func queryHomeVideosFromDataManager() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.dataManager.fetchHomeVideosFromDataManager()
        }
    }
    func queryTrendingVideosFromDataManager() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.dataManager.fetchTrendingVideosFromDataManager()
        }
    }
    func querySubscriptionsVideosFromDataManager() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.dataManager.fetchSubscriptionsVideosFromDataManager()
        }
    }
    func queryAccountVideosFromDataManager() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.dataManager.fetchAccountVideosFromDataManager()
        }
    }
    //MARK:-YoutubeDataManagerInput
    func didHandleErrorFromFetchingRequest(_ error: String) {
        self.view?.didHandleError(error)
    }
    func didFetchFeedVideosFromAPI(_ videos: [YoutubeVideoItem]) {
        self.videos = videos
        self.view?.didFinishUpdates()
    }
}
extension YoutubeTimelineViewModel {
    func selectedItemAt(indexPath: IndexPath) -> YoutubeVideoItem {
        return videos[indexPath.item]
    }
    func numerOfItemsInSection(section: Int) -> Int {
        return videos.count
    }
}












