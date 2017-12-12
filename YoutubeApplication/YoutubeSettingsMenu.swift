//
//  YoutubeSettingsMenu.swift
//  YoutubeApplication
//
//  Created by wSong on 12/11/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation
protocol YoutubeSettingsMenuItem {
    var settingsTitle: String {get set}
    var settingsImageName: String {get set}
}
struct YoutubeSettingsMenu: YoutubeSettingsMenuItem {
    var settingsTitle: String
    var settingsImageName: String
}
