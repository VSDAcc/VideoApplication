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
    func showYoutubeDetailViewController(_ video: YoutubeVideo)
}
protocol YoutubeMainTimelineViewModelOutput: class {
    func viewModelDidLoadData(_ viewModel: YoutubeMainTimelineViewModelInput)
    func viewModelWillLoadData(_ viewModel: YoutubeMainTimelineViewModelInput)
    func viewModel(_ viewModel: YoutubeMainTimelineViewModelInput, didHandleError error: String)
    func viewModel(_ viewModel: YoutubeMainTimelineViewModelInput, didSelectVideoModel model: YotubeTimelineVideoCellModel, cell: YoutubeTimelineVideoCollectionViewCell)
}
protocol YoutubeMainTimelineViewModelInput: ViewModelCellPresentable, YoutubeSettingsMenuHandler, YoutubeTimelineVideoSectionModelHandler {
    var coordinator: YoutubeMainTimelineViewModelCoordinatorDelegate? {get set}
    var view: YoutubeMainTimelineViewModelOutput? {get set}
    func loadVideoData()
    func updateHomeVideos()
    func updateTrendingVideos()
    func updateAccountVideos()
    func updateSubscriptionVideos()
    func showYoutubeDetailViewController(_ video: YoutubeVideo)
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
         _ timelineSubscriptionVideoServices: TimelineSubscriptionVideoServicesInput = TimelineSubscriptionVideoServices(),
         _ timelineCoordinator: YoutubeMainTimelineViewModelCoordinatorDelegate? = nil) {
        homeVideoServices = timelineHomeVideoServices
        trendingVideoServices = timelineTrendingVideoServices
        accountVideoServices = timelineAccountVideoServices
        subscriptionVideoServices = timelineSubscriptionVideoServices
        coordinator = timelineCoordinator
        homeSection.delegate = self
        trendingSection.delegate = self
        subscriptionSection.delegate = self
        accountSection.delegate = self
    }
    //MARK:-YoutubeMainTimelineViewModelInput
    public func loadVideoData() {
        sections = [homeSection, trendingSection, subscriptionSection, accountSection]
        homeSection.updateVideoSectionModel(homeVideoServices.queryHomeVideos())
        trendingSection.updateVideoSectionModel(trendingVideoServices.queryTrendingVideos())
        accountSection.updateVideoSectionModel(accountVideoServices.queryAccountVideos())
        subscriptionSection.updateVideoSectionModel(subscriptionVideoServices.querySubscriptionVideos())
        view?.viewModelDidLoadData(self)
    }
    
    public func updateHomeVideos() {
        homeVideoServices.updateHomeVideos { [weak self] (videos) in
            guard let strongSelf = self else { return }
            strongSelf.homeSection.updateVideoSectionModel(videos)
            strongSelf.view?.viewModelDidLoadData(strongSelf)
        }
    }
    
    public func updateTrendingVideos() {
        trendingVideoServices.updateTrendingVideos { [weak self] (videos) in
            guard let strongSelf = self else { return }
            strongSelf.trendingSection.updateVideoSectionModel(videos)
            strongSelf.view?.viewModelDidLoadData(strongSelf)
        }
    }
    
    public func updateAccountVideos() {
        homeVideoServices.updateHomeVideos { [weak self] (videos) in
            guard let strongSelf = self else { return }
            strongSelf.accountSection.updateVideoSectionModel(videos)
            strongSelf.view?.viewModelDidLoadData(strongSelf)
        }
    }
    
    public func updateSubscriptionVideos() {
        subscriptionVideoServices.updateSubscriptionVideos { [weak self] (videos) in
            guard let strongSelf = self else { return }
            strongSelf.subscriptionSection.updateVideoSectionModel(videos)
            strongSelf.view?.viewModelDidLoadData(strongSelf)
        }
    }
    
    func showYoutubeDetailViewController(_ video: YoutubeVideo) {
        coordinator?.showYoutubeDetailViewController(video)
    }
    //MARK:-YoutubeTimelineVideoSectionModelHandler
    func didSelectVideoModel(_ model: YotubeTimelineVideoCellModel, cell: YoutubeTimelineVideoCollectionViewCell) {
        view?.viewModel(self, didSelectVideoModel: model, cell: cell)
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
extension YoutubeMainTimelineViewModel {
    
    func didPressedSettingsMenu(settings: YoutubeSettingsMenuItem) {
        
        print(settings.settingsTitle)
    }
    
    func didPressedTermsAndPrivacyMenu(settings: YoutubeSettingsMenuItem) {
        print(settings.settingsTitle)
    }
    
    func didPressedSendFeedbackMenu(settings: YoutubeSettingsMenuItem) {
        print(settings.settingsTitle)
    }
    
    func didPressedHelpMenu(settings: YoutubeSettingsMenuItem) {
        print(settings.settingsTitle)
    }
    
    func didPressedSwitchAccountMenu(settings: YoutubeSettingsMenuItem) {
        print(settings.settingsTitle)
    }
    
    func didPressedCancelMenu(settings: YoutubeSettingsMenuItem) {
        print(settings.settingsTitle)
    }
}
