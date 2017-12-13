//
//  YoutubeMenuBar.swift
//  YoutubeApplication
//
//  Created by wSong on 12/11/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation
enum YoutubeMenuBarImageNameItem: String, CustomStringConvertible {
    case home = "home"
    case trending = "trending"
    case subscriptions = "subscriptions"
    case account = "account"
    var description: String {
        return self.rawValue
    }
}
protocol YoutubeMenuBarItem {
    var itemImageName: YoutubeMenuBarImageNameItem {get}
}
struct YoutubeMenuBar: YoutubeMenuBarItem {
    var itemImageName: YoutubeMenuBarImageNameItem
}
