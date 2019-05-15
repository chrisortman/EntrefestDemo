//
//  DiscoveryRequest.swift
//  EntrefestDemo
//
//  Created by Ortman, Chris E on 5/14/19.
//  Copyright © 2019 Chris Ortman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct DiscoveryRequest : URLRequestConvertible {
    let version : String
    let platform : String = "ios"
    
    init(version : String) {
        self.version = version
    }
    
    init() {
        let version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        if let version = version {
            self.init(version: version)
        } else {
            self.init(version: "0.0.0")
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        
        let url = URL(string: "https://raw.githubusercontent.com/chrisortman/EntrefestDemo/master/discovery/\(platform)/\(version)/index.json")
        var mutableURLRequest = URLRequest(url: url!)
        mutableURLRequest.httpMethod = "GET"
        mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        return mutableURLRequest
        
    }
}

struct DiscoveryResponse {
    var apiUrl: URL
    var enablePush: Bool
    
    static let defaultValues = DiscoveryResponse(
        apiUrl: URL(string: "http://localhost:3000")!,
        enablePush: false
    )
    
    init(apiUrl: URL, enablePush: Bool) {
        self.apiUrl = apiUrl
        self.enablePush = enablePush
    }
    
    init?(from json : JSON) {
        
        guard let url = json["discovery"]["apiUrl"].url else { return nil}
        guard let enablePush = json["discovery"]["enablePush"].bool else { return nil }
        
        self.apiUrl = url
        self.enablePush = enablePush
        
    }
}
