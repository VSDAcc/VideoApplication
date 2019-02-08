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
    
    fileprivate var group = DispatchGroup()
    fileprivate var sections = [SectionRowsRepresentable]()
    fileprivate var homeSection = YoutubeTimelineVideoContainerSectionModel()
    fileprivate var subscriptionSection = YoutubeTimelineVideoContainerSectionModel()
    fileprivate var accountSection = YoutubeTimelineVideoContainerSectionModel()
    fileprivate var trendingSection = YoutubeTimelineVideoContainerSectionModel()
    fileprivate var videoServices: TimelineVideoServicesDelegate
    
    //MARK:-Loading
    init(_ videoServices: TimelineVideoServicesDelegate = TimelineVideoServices(),
         _ timelineCoordinator: YoutubeMainTimelineViewModelCoordinatorDelegate? = nil) {
        self.videoServices = videoServices
        coordinator = timelineCoordinator
        homeSection.delegate = self
        trendingSection.delegate = self
        subscriptionSection.delegate = self
        accountSection.delegate = self
    }
    //MARK:-YoutubeMainTimelineViewModelInput
    public func loadVideoData() {
        group.enter()
        sections = [homeSection, trendingSection, subscriptionSection, accountSection]
        homeSection.updateVideoSectionModel(videoServices.queryVideos(with: .homeVideos))
        trendingSection.updateVideoSectionModel(videoServices.queryVideos(with: .trendingVideos))
        accountSection.updateVideoSectionModel(videoServices.queryVideos(with: .accountVideos))
        subscriptionSection.updateVideoSectionModel(videoServices.queryVideos(with: .subscriptionVideos))
        group.leave()
        group.notify(queue: .main) {
            self.view?.viewModelDidLoadData(self)
        }
    }
    
    public func updateHomeVideos() {
        videoServices.updateVideos(with: .homeVideos) { [weak self] (videos) in
            guard let strongSelf = self else { return }
            strongSelf.homeSection.updateVideoSectionModel(videos)
            strongSelf.view?.viewModelDidLoadData(strongSelf)
        }
    }
    
    public func updateTrendingVideos() {
        videoServices.updateVideos(with: .trendingVideos) { [weak self] (videos) in
            guard let strongSelf = self else { return }
            strongSelf.trendingSection.updateVideoSectionModel(videos)
            strongSelf.view?.viewModelDidLoadData(strongSelf)
        }
    }
    
    public func updateAccountVideos() {
        videoServices.updateVideos(with: .homeVideos) { [weak self] (videos) in
            guard let strongSelf = self else { return }
            strongSelf.accountSection.updateVideoSectionModel(videos)
            strongSelf.view?.viewModelDidLoadData(strongSelf)
        }
    }
    
    public func updateSubscriptionVideos() {
        videoServices.updateVideos(with: .subscriptionVideos) { [weak self] (videos) in
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
