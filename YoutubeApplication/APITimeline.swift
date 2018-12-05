//
//  APITimeline.swift
//  YoutubeApplication
//
//  Created by Vladymyr on 12/5/18.
//  Copyright © 2018 VladymyrShorokhov. All rights reserved.
//

import Foundation
import Moya

enum APITimeline {
    case homeVideos
    case trendingVideos
    case subscriptionVideos
    case accountVideos
}
extension APITimeline: TargetType {
    
    var path: String {
        switch self {
        case .homeVideos: return "/youtubeassets/home.json"
        case .trendingVideos: return "/youtubeassets/trending.json"
        case .subscriptionVideos: return "/youtubeassets/subscriptions.json"
        case .accountVideos: return "/youtubeassets/account.json"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .homeVideos, .trendingVideos, .subscriptionVideos, .accountVideos:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .homeVideos:
            return Task.requestParameters(parameters: {
                let parameters = [String : Any]()
                return parameters
            }(), encoding: JSONEncoding.prettyPrinted)
        case .trendingVideos:
            return Task.requestParameters(parameters: {
                let parameters = [String : Any]()
                return parameters
            }(), encoding: JSONEncoding.prettyPrinted)
        case .subscriptionVideos:
            return Task.requestParameters(parameters: {
                let parameters = [String : Any]()
                return parameters
            }(), encoding: JSONEncoding.prettyPrinted)
        case .accountVideos:
            return Task.requestParameters(parameters: {
                let parameters = [String : Any]()
                return parameters
            }(), encoding: JSONEncoding.prettyPrinted)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .homeVideos, .trendingVideos, .subscriptionVideos, .accountVideos:
            return ["Content-type" : "application/json"]
        }
    }
}
