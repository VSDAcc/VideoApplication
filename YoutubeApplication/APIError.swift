//
//  APIError.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 11/21/18.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import Foundation
import Moya

enum APIError: Swift.Error {
    
    case loginError(reason: String?)
    case clientRequestError(reason: String?)
    case clientInternalError(reason: String?)
    case serverInternalError(reason: String?)
    
    var title: String {
        return "oops_error_message".localized
    }
    
    var description: String {
        switch self {
        case let .loginError(reason):
            return reason ?? "Unknown error!"
        case let .clientRequestError(reason):
            return reason ?? "Unknown error!"
        case let .clientInternalError(reason):
            return reason ?? "Unknown error!"
        case let .serverInternalError(reason):
            return reason ?? "Internal server error, try again latter."
        }
    }
    
    var localizedDescription: String {
        return self.description.localized
    }
}
