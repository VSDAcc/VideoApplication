//
//  ApplicationStorage.swift
//  UranC.TestApp
//
//  Created by Vladymyr on 11/24/18.
//  Copyright © 2018 VSDAcc. All rights reserved.
//

import Foundation
import Cache

public struct Cashable: Codable { }
class AppStorage {
    
    public enum AppStoragePriority {
        case permanent
        case cache
    }
    
    private static var permanentStorage: Storage = try! Storage(
        diskConfig: AppCachePreferences.Permanent.diskConfig,
        memoryConfig: AppCachePreferences.Permanent.memoryConfig,
        transformer: TransformerFactory.forCodable(ofType: Cashable.self)
    )
    
    private static var cacheStorage: Storage = try! Storage(
        diskConfig: AppCachePreferences.Cache.diskConfig,
        memoryConfig: AppCachePreferences.Cache.memoryConfig,
        transformer: TransformerFactory.forCodable(ofType: Cashable.self)
    )
    
    static func setObject<T>(_ object: T, forKey key: String, priority: AppStoragePriority = .cache) where T: Codable {
        switch priority {
        case .permanent:
            try? permanentStorage.transformCodable(ofType: T.self).setObject(object, forKey: key)
        case .cache:
            try? cacheStorage.transformCodable(ofType: T.self).setObject(object, forKey: key)
        }
    }
    
    static func getObject<T>(ofType type: T.Type, forKey key: String, priority: AppStoragePriority = .cache) -> T? where T: Codable {
        switch priority {
        case .permanent:
            return try? permanentStorage.transformCodable(ofType: T.self).object(forKey: key)
        case .cache:
            return try? cacheStorage.transformCodable(ofType: T.self).object(forKey: key)
        }
    }
    
    static func removeObject(forKey key: String, priority: AppStoragePriority = .cache) {
        switch priority {
        case .permanent:
            try? permanentStorage.removeObject(forKey: key)
        case .cache:
            try? cacheStorage.removeObject(forKey: key)
        }
    }
    
    static func clearPreferences() {
        try? permanentStorage.removeAll()
    }
    
    static func clearCache() {
        try? cacheStorage.removeAll()
    }
}

struct AppCachePreferences {
    
    static var directory: URL {
        return try! FileManager.default.url(for: .documentDirectory,
                                            in: .userDomainMask,
                                            appropriateFor: nil,
                                            create: true).appendingPathComponent("YoutubeApplicationStorage")
    }
    
    struct Permanent {
        
        static let diskConfig = DiskConfig(name: "com.youtubeApplication.permanent",
                                           expiry: .never,
                                           maxSize: (1^20) * 256,
                                           directory: AppCachePreferences.directory.appendingPathComponent("preferences"),
                                           protectionType: .complete)
        
        static let memoryConfig = MemoryConfig(expiry: .never,
                                               countLimit: 25,
                                               totalCostLimit: 5)
    }
    
    struct Cache {
        
        static let diskConfig = DiskConfig(name: "com.youtubeApplication.cache",
                                           expiry: .date(Date().addingTimeInterval(6*3600)),
                                           maxSize: (1^20) * 128,
                                           directory: AppCachePreferences.directory.appendingPathComponent("cache"),
                                           protectionType: .complete)
        
        static let memoryConfig = MemoryConfig(expiry: .never,
                                               countLimit: 25,
                                               totalCostLimit: 5)
    }
}
