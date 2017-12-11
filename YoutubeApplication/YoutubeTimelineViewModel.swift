//
//  YoutubeTimelineViewModel.swift
//  YoutubeApplication
//
//  Created by wSong on 12/5/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation
protocol YoutubeViewModelOutput: YoutubeDataManagerInput {
   func queryVideosFromDataManager()
}
class YoutubeTimelineViewModel: YoutubeViewModelOutput {
    fileprivate var videos = [YoutubeVideoItem]()
    var dataManager = YoutubeDataManager()
    weak var view: YoutubeTimelineViewControllerInput?
    init() {
        dataManager.managerInput = self
        queryVideosFromDataManager()
    }
    //MARK:-YoutubeViewModelOutput
    func queryVideosFromDataManager() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.dataManager.fetchFeedVideosFromAPI()
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












