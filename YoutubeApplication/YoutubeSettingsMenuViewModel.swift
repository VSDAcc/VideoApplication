//
//  YoutubeSettingsMenuViewModel.swift
//  YoutubeApplication
//
//  Created by wSong on 12/11/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation
class YoutubeSettingsMenuViewModel {
    fileprivate var menuSettingsArray = [YoutubeSettingsMenu(settingsTitle: "asdsad", settingsImageName: "Street"), YoutubeSettingsMenu(settingsTitle: "asdsad", settingsImageName: "Street"),YoutubeSettingsMenu(settingsTitle: "asdsad", settingsImageName: "Street"),YoutubeSettingsMenu(settingsTitle: "asdsad", settingsImageName: "Street"),YoutubeSettingsMenu(settingsTitle: "asdsad", settingsImageName: "Street"),YoutubeSettingsMenu(settingsTitle: "asdsad", settingsImageName: "Street")]
}
extension YoutubeSettingsMenuViewModel {
    func selectedItemAt(indexPath: IndexPath) -> YoutubeSettingsMenuItem {
        return menuSettingsArray[indexPath.item]
    }
    func numerOfItemsInSection(section: Int) -> Int {
        return menuSettingsArray.count
    }
}
