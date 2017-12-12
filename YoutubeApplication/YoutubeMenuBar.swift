//
//  YoutubeMenuBar.swift
//  YoutubeApplication
//
//  Created by wSong on 12/11/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import Foundation
protocol YoutubeMenuBarItem {
    var itemImageName: String {get set}
}
struct YoutubeMenuBar: YoutubeMenuBarItem {
    var itemImageName: String
}
