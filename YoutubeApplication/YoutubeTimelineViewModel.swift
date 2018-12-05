//
//  YoutubeTimelineViewModel.swift
//  YoutubeApplication
//
//  Created by wSong on 12/5/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation

protocol YoutubeViewModelOutput: YoutubeDataManagerOutput {
    func queryHomeVideosFromDataManager()
    func queryTrendingVideosFromDataManager()
    func querySubscriptionsVideosFromDataManager()
    func queryAccountVideosFromDataManager()
}
class YoutubeTimelineViewModel: YoutubeViewModelOutput {
    
    fileprivate var youtubeVideos = [YoutubeVideoModel]()
    fileprivate var dataManager = YoutubeDataManager()
    weak var view: YoutubeTimelineViewControllerInput?
    
    //MARK:-Loading
    init() {
        dataManager.managerOutput = self
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
    
    func didHandleFetchRequestWith(_ videos: [YoutubeVideoModel]) {
        self.youtubeVideos = videos
        self.view?.didFinishUpdates()
    }
}
extension YoutubeTimelineViewModel {
    
    func selectedItemAt(indexPath: IndexPath) -> YoutubeVideoModel {
        return youtubeVideos[indexPath.item]
    }
    
    func numerOfItemsInSection(section: Int? = nil) -> Int {
        return youtubeVideos.count
    }
}
