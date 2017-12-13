//
//  YoutubeSettingsMenu.swift
//  YoutubeApplication
//
//  Created by wSong on 12/11/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation
enum YoutubeSettingsMenuTitleNameItem: String, CustomStringConvertible {
    case settings = "Settings"
    case termsPrivacy = "Terms & Privacy policy"
    case sendFeedback = "Send Feedback"
    case help = "Help"
    case switchAccount = "Switch Account"
    case cancel = "Cancel"
    var description: String {
        return self.rawValue
    }
}
enum YoutubeSettingsMenuImageNameItem: String, CustomStringConvertible{
    case settings = "settings"
    case termsPrivacy = "privacy"
    case sendFeedback = "feedback"
    case help = "help"
    case switchAccount = "switch_account"
    case cancel = "cancel"
    var description: String {
        return self.rawValue
    }
}
protocol YoutubeSettingsMenuItem {
    var settingsTitle: YoutubeSettingsMenuTitleNameItem {get}
    var settingsImageName: YoutubeSettingsMenuImageNameItem {get}
}
struct YoutubeSettingsMenu: YoutubeSettingsMenuItem {
    var settingsTitle: YoutubeSettingsMenuTitleNameItem
    var settingsImageName: YoutubeSettingsMenuImageNameItem
}
