//
//  Models.swift
//  EntrefestDemo
//
//  Created by Ortman, Chris E on 5/14/19.
//  Copyright © 2019 Chris Ortman. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var text = ""
    @objc dynamic var createdAt = Date()
    @objc dynamic var notCompletedAt: Date? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    func updateFrom(itemForm values: [String: Any?]) {
        self.text = values["TextField"] as? String ?? ""
    }
    
    func sayNo() {
        self.notCompletedAt = Date()
    }
}
