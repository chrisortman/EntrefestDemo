//
//  Realms.swift
//  EntrefestDemo
//
//  Created by Ortman, Chris E on 5/14/19.
//  Copyright © 2019 Chris Ortman. All rights reserved.
//

import Foundation
import RealmSwift

/**
 Default Realm used to store data entered by the user or downloaded
 from the PHR Server
 */

private let realmStorageDir = Realm.Configuration.defaultConfiguration
    .fileURL!
    .deletingLastPathComponent()
    .appendingPathComponent("RealmData")


fileprivate let UserRealmConfiguration = Realm.Configuration(
    fileURL: realmStorageDir.appendingPathComponent("user.realm"),
    schemaVersion: 9,
    migrationBlock: { migration, oldSchemaVersion in
        if (oldSchemaVersion < 9) {
            // Changed UploadConfiguration to user UserDefaults
            
        }
        
       
    },
    objectTypes : [Item.self]
)

func initializeRealms() {
    
    print("REALM DIRECTORY: \(realmStorageDir.path)")
    
    let manager = FileManager.default
    if !manager.fileExists(atPath: realmStorageDir.path) {
        //Special attributes needed here in order to allow background updates to write to
        //the realm file.
        try! manager.createDirectory(at: realmStorageDir, withIntermediateDirectories: true, attributes: [
            FileAttributeKey(rawValue: FileAttributeKey.protectionKey.rawValue): FileProtectionType.completeUntilFirstUserAuthentication
            ])
    }
    
    Realm.Configuration.defaultConfiguration = UserRealmConfiguration
    
}

