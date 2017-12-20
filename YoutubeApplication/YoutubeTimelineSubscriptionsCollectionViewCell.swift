//
//  YoutubeTimelineSubscriptionsCollectionViewCell.swift
//  YoutubeApplication
//
//  Created by wSong on 12/18/17.
//  Copyright © 2017 VladymyrShorokhov. All rights reserved.
//

import UIKit

class YoutubeTimelineSubscriptionsCollectionViewCell: YoutubeTimelineContainerCollectionViewCell {
    
    override func fetchVideosFromDataManager() {
        viewModel.querySubscriptionsVideosFromDataManager()
    }
}
