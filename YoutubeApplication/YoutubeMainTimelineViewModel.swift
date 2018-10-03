//
//  YoutubeMainTimelineViewModel.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 09.02.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import Foundation
import UIKit

class YoutubeMainTimelineViewModel {
    
    fileprivate var router: YoutubeTimelineRouter.Routes?
    convenience init(router: YoutubeTimelineRouter.Routes) {
        self.init()
        self.router = router
    }
    
    func openDetailYoutubeViewController(youtubeVideoItem video: YoutubeVideoModel, animatableCells: [UICollectionViewCell]) {
        router?.openDetail(for: video, animatableYoutubeCells: animatableCells)
    }
}
