//
//  YoutubeMenuBarViewModel.swift
//  YoutubeApplication
//
//  Created by wSong on 12/7/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation
class YoutubeMenuBarViewModel {
    fileprivate var menuBarArray = [
        YoutubeMenuBar(itemImageName: .home, itemTitleName: .home),
        YoutubeMenuBar(itemImageName: .trending, itemTitleName: .trending),
        YoutubeMenuBar(itemImageName: .subscriptions, itemTitleName: .subscriptions),
        YoutubeMenuBar(itemImageName: .account, itemTitleName: .account)
    ]
}
extension YoutubeMenuBarViewModel {
    func selectedItemAt(indexPath: IndexPath) -> YoutubeMenuBarItem {
        return menuBarArray[indexPath.item]
    }
    func numerOfItemsInSection(section: Int) -> Int {
        return menuBarArray.count
    }
}
