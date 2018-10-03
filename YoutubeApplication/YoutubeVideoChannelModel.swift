//
//  YoutubeVideoChannelModel.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 05.01.2018.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import CoreData
import UIKit

class YoutubeVideoChannelModel: NSManagedObject {
    
    class func findOrCreateYoutubeVideoChannel(matching videoChannelInfo: YoutubeVideoChannelItem, in context: NSManagedObjectContext) throws -> YoutubeVideoChannelModel {
        
        let fetchRequest: NSFetchRequest<YoutubeVideoChannelModel> = YoutubeVideoChannelModel.fetchRequest()
        let predicate = NSPredicate(format: "channelName = %@", videoChannelInfo.channelName)
        fetchRequest.predicate = predicate
        do {
            let matches = try context.fetch(fetchRequest)
            if matches.count > 0 {
                assert(matches.count == 1, "YoutubeVideoChannelModel.findOrCreateYoutubeVideoChannel - databse inconsistency")
                return matches[0]
            }
        } catch {
            throw error
        }
        let videoChannelModel = YoutubeVideoChannelModel(context: context)
        videoChannelModel.channelName = videoChannelInfo.channelName
        videoChannelModel.channelProfileImageLink = videoChannelInfo.channelProfileImageLink
        
        return videoChannelModel
    }
}
