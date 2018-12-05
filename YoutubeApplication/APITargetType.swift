//
//  APITarget.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 11/21/18.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import Foundation
import Moya

extension TargetType {
    
    var baseURL: URL {
        return Configuration.requiredEndpoint
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return ["accept" : "application/json"]
    }
}
