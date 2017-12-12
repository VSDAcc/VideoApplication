//
//  YoutubeSettingsMenuViewModel.swift
//  YoutubeApplication
//
//  Created by wSong on 12/11/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation
class YoutubeSettingsMenuViewModel {
    fileprivate var menuSettingsArray = [YoutubeSettingsMenu(settingsTitle: "Settings", settingsImageName: "settings"), YoutubeSettingsMenu(settingsTitle: "Terms & Privacy policy", settingsImageName: "privacy"),YoutubeSettingsMenu(settingsTitle: "Send Feedback", settingsImageName: "feedback"),YoutubeSettingsMenu(settingsTitle: "Help", settingsImageName: "help"),YoutubeSettingsMenu(settingsTitle: "Switch Account", settingsImageName: "switch_account"),YoutubeSettingsMenu(settingsTitle: "Cancel", settingsImageName: "cancel")]
}
extension YoutubeSettingsMenuViewModel {
    func selectedItemAt(indexPath: IndexPath) -> YoutubeSettingsMenuItem {
        return menuSettingsArray[indexPath.item]
    }
    func numerOfItemsInSection(section: Int) -> Int {
        return menuSettingsArray.count
    }
}
