//
//  Handler.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 11/21/18.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import Foundation
import Moya
import Result

protocol Handler {
    
}

extension Handler {

    static func handle(result: APIResult, onSuccess: ((Response) -> Void)? = nil, onError: ((APIError) -> Void)? = nil) {
        switch result {
        case let .failure(error):
            onError?(error)
        case let .success(response):
            onSuccess?(response)
        }
    }

    func handle(result: APIResult, onSuccess: ((Response) -> Void)? = nil, onError: ((APIError) -> Void)? = nil) {
        switch result {
        case let .failure(error):
            onError?(error)
        case let .success(response):
            onSuccess?(response)
        }
    }
}
