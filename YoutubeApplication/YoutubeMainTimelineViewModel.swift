//
//  YoutubeMainTimelineViewModel.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 09.02.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import Foundation
import UIKit

protocol YoutubeMainTimelineViewModelCoordinatorDelegate: class {
    func showYoutubeDetailViewController(_ viewModel: YoutubeDetailVideoViewModelInput)
}
protocol YoutubeMainTimelineViewModelOutput: class {
    func viewModelDidLoadData()
    func viewModelWillLoadData()
    func viewModelDidHandleError(_ error: String)
}
protocol YoutubeMainTimelineViewModelInput: ViewModelCellPresentable {
    var coordinator: YoutubeMainTimelineViewModelCoordinatorDelegate? {get set}
    var view: YoutubeMainTimelineViewModelOutput? {get set}
    func loadVideoData()
    func updateHomeVideos()
    func updateTrendingVideos()
    func updateAccountVideos()
    func updateSubscriptionVideos()
}
class YoutubeMainTimelineViewModel: YoutubeMainTimelineViewModelInput {
    
    weak var coordinator: YoutubeMainTimelineViewModelCoordinatorDelegate?
    weak var view: YoutubeMainTimelineViewModelOutput?
    
    fileprivate var sections = [SectionRowsRepresentable]()
    fileprivate var homeSection = YoutubeTimelineVideoContainerSectionModel()
    fileprivate var subscriptionSection = YoutubeTimelineVideoContainerSectionModel()
    fileprivate var accountSection = YoutubeTimelineVideoContainerSectionModel()
    fileprivate var trendingSection = YoutubeTimelineVideoContainerSectionModel()
    
    fileprivate var homeVideoServices: TimelineHomeVideoServicesInput
    fileprivate var trendingVideoServices: TimelineTrendingVideoServicesInput
    fileprivate var accountVideoServices: TimelineAccountVideoServicesInput
    fileprivate var subscriptionVideoServices: TimelineSubscriptionVideoServicesInput
    
    //MARK:-Loading
    init(_ timelineHomeVideoServices: TimelineHomeVideoServicesInput = TimelineHomeVideoServices(),
         _ timelineTrendingVideoServices: TimelineTrendingVideoServicesInput = TimelineTrendingVideoServices(),
         _ timelineAccountVideoServices: TimelineAccountVideoServicesInput = TimelineAccountVideoServices(),
         _ timelineSubscriptionVideoServices: TimelineSubscriptionVideoServicesInput = TimelineSubscriptionVideoServices()) {
        self.homeVideoServices = timelineHomeVideoServices
        self.trendingVideoServices = timelineTrendingVideoServices
        self.accountVideoServices = timelineAccountVideoServices
        self.subscriptionVideoServices = timelineSubscriptionVideoServices
    }
    //MARK:-YoutubeMainTimelineViewModelInput
    public func loadVideoData() {
        sections = [homeSection, trendingSection, subscriptionSection, accountSection]
        homeSection.updateVideoSectionModel(homeVideoServices.queryHomeVideos())
        trendingSection.updateVideoSectionModel(trendingVideoServices.queryTrendingVideos())
        accountSection.updateVideoSectionModel(accountVideoServices.queryAccountVideos())
        subscriptionSection.updateVideoSectionModel(subscriptionVideoServices.querySubscriptionVideos())
        view?.viewModelDidLoadData()
    }
    
    public func updateHomeVideos() {
        homeVideoServices.updateHomeVideos { [weak self] (videos) in
            print("updateHomeVideos \(videos.count)")
            self?.homeSection.updateVideoSectionModel(videos)
            self?.view?.viewModelDidLoadData()
        }
    }
    
    public func updateTrendingVideos() {
        trendingVideoServices.updateTrendingVideos { [weak self] (videos) in
            print("updateTrendingVideos \(videos.count)")
            self?.trendingSection.updateVideoSectionModel(videos)
            self?.view?.viewModelDidLoadData()
        }
    }
    
    public func updateAccountVideos() {
        homeVideoServices.updateHomeVideos { [weak self] (videos) in
            print("updateAccountVideos \(videos.count)")
            self?.accountSection.updateVideoSectionModel(videos)
            self?.view?.viewModelDidLoadData()
        }
    }
    
    public func updateSubscriptionVideos() {
        subscriptionVideoServices.updateSubscriptionVideos { [weak self] (videos) in
            print("updateSubscriptionVideos \(videos.count)")
            self?.subscriptionSection.updateVideoSectionModel(videos)
            self?.view?.viewModelDidLoadData()
        }
    }
}
extension YoutubeMainTimelineViewModel {
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func selectedItemAt(section: Int, atIndex: Int) -> CellIdentifiable {
        return sections[section].rows[atIndex]
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        return sections[section].rows.count
    }
}
