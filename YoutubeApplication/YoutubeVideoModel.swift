//
//  YoutubeVideoModel.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 05.01.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import UIKit
import CoreData

class YoutubeVideoModel: NSManagedObject {
    
    class func findOrCreateYoutubeVideo(matching videoInfo: YoutubeVideo, in context: NSManagedObjectContext) throws -> YoutubeVideoModel {
        
        let fetchRequest: NSFetchRequest<YoutubeVideoModel> = YoutubeVideoModel.fetchRequest()
        let predicate = NSPredicate(format: "videoTitle = %@", videoInfo.videoTitle)
        fetchRequest.predicate = predicate
        do {
           let matches = try context.fetch(fetchRequest)
            if matches.count > 0 {
                assert(matches.count == 1, "YoutubeVideoModel.findOrCreateYoutubeVideo - databse inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        let videoModel = YoutubeVideoModel(context: context)
        videoModel.videoDuration = Int64(videoInfo.videoDuration)
        videoModel.videoLinkURL = videoInfo.videoLinkUrl
        videoModel.videoTitle = videoInfo.videoTitle
        videoModel.videoThumbnailImage = videoInfo.thumbnailImage
        videoModel.videoNumberOfViews = Int64(videoInfo.videoNumberOfViews)
        videoModel.channel = try? YoutubeVideoChannelModel.findOrCreateYoutubeVideoChannel(matching: videoInfo.channel!, in: context)

        return videoModel
    }
}
class YoutubeHomeVideoModel: YoutubeVideoModel {
    
}
class YoutubeAccountVideoModel: YoutubeVideoModel {
    
}
class YoutubeSubscriptionVideoModel: YoutubeVideoModel {
    
}
class YuotubeTrendingVideoModel: YoutubeVideoModel {
    
}
