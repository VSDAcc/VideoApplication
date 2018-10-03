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
enum YoutubeMenuBarTitleNameItem: String, CustomStringConvertible {
    case home = "Home"
    case trending = "Trending"
    case subscriptions = "Subscriptions"
    case account = "Account"
    var description: String {
        return self.rawValue
    }
}
protocol YoutubeMenuBarItem {
    var itemImageName: YoutubeMenuBarImageNameItem {get}
    var itemTitleName: YoutubeMenuBarTitleNameItem {get}
}
struct YoutubeMenuBar: YoutubeMenuBarItem {
    var itemImageName: YoutubeMenuBarImageNameItem
    var itemTitleName: YoutubeMenuBarTitleNameItem
}
