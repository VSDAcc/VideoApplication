//
//  YoutubeSettingsMenuViewModel.swift
//  YoutubeApplication
//
//  Created by wSong on 12/11/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation

class YoutubeSettingsMenuViewModel {
    
    fileprivate var menuSettingsArray = [
        YoutubeSettingsMenu(settingsTitle: .settings, settingsImageName: .settings),
        YoutubeSettingsMenu(settingsTitle: .termsPrivacy, settingsImageName: .termsPrivacy),
        YoutubeSettingsMenu(settingsTitle: .sendFeedback, settingsImageName: .sendFeedback),
        YoutubeSettingsMenu(settingsTitle: .help, settingsImageName: .help),
        YoutubeSettingsMenu(settingsTitle: .switchAccount, settingsImageName: .switchAccount),
        YoutubeSettingsMenu(settingsTitle: .cancel, settingsImageName: .cancel)
    ]
}
extension YoutubeSettingsMenuViewModel {
    
    func selectedItemAt(indexPath: IndexPath) -> YoutubeSettingsMenuItem {
        return menuSettingsArray[indexPath.item]
    }
    
    func numerOfItemsInSection(section: Int) -> Int {
        return menuSettingsArray.count
    }
}
