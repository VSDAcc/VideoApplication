//
//  DispatchQueue.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 11/21/18.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static let networking = DispatchQueue(label: "com.youtubeApplication.networking",
                                          qos: .default,
                                          attributes: .concurrent,
                                          autoreleaseFrequency: .inherit,
                                          target: nil)
    
    static let background = DispatchQueue(label: "com.youtubeApplication.background",
                                          qos: .background,
                                          attributes: .concurrent,
                                          autoreleaseFrequency: .inherit,
                                          target: nil)
    
    static let monitoring = DispatchQueue(label: "com.youtubeApplication.monitoring",
                                          qos: .utility,
                                          attributes: .concurrent,
                                          autoreleaseFrequency: .inherit,
                                          target: nil)
}
