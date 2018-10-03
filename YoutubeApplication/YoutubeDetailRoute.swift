//
//  YoutubeDetailRoute.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 03.02.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit

protocol YoutubeDetailRoute {
    var youtubeDetailTransition: Transition {get}
    func openDetail(for youtubeDetailModel: YoutubeVideoModel, animatableYoutubeCells: [UICollectionViewCell])
}
extension YoutubeDetailRoute where Self: RouterProtocol {
    
    var youtubeDetailTransition: Transition {
        return PushTransition()
    }
    func openDetail(for youtubeDetailModel: YoutubeVideoModel, animatableYoutubeCells: [UICollectionViewCell]) {
        let router = YoutubeDetailRouter()
        let youtubeDetailViewModel = YoutubeDetailVideoViewModel(videoItem: youtubeDetailModel, router: router)
        let detailViewController = YoutubeDetailVideoViewController(viewModel: youtubeDetailViewModel)
        detailViewController.animatableYoutubeCells = animatableYoutubeCells
        router.viewController = detailViewController
        
        let transition = youtubeDetailTransition
        router.openTransition = transition
        open(detailViewController, transition: transition)
    }
}
final class YoutubeTimelineRouter: Router<YoutubeTimelineViewController>, YoutubeTimelineRouter.Routes {
    typealias Routes = YoutubeDetailRoute
}
final class YoutubeDetailRouter: Router<YoutubeDetailVideoViewController> {
    typealias Routes = Closable
}
