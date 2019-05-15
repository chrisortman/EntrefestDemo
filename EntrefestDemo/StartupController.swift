//
//  DiscoveryController.swift
//  EntrefestDemo
//
//  Created by Ortman, Chris E on 5/14/19.
//  Copyright © 2019 Chris Ortman. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

var DiscoveredSettings = DiscoveryResponse.defaultValues

class StartupController : UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        self.startDiscovery {
            self.activityIndicator.stopAnimating()
            self.performSegue(withIdentifier: "Main", sender: self)
        }
    }
    
    private func startDiscovery(success: @escaping () -> Void) {
        
        let request = Alamofire.request(DiscoveryRequest())
        print("Look, it will print the cURL command if you want to test it")
        debugPrint(request)
        
        request.responseJSON { response in
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                if let parsed = DiscoveryResponse(from: json) {
                    DiscoveredSettings = parsed
                }
                success()
                break
                
            case let .failure(err):
                print(err)
                //We failed on discovery, hopefully we have enough settings to get us by
                //we will deal with that in context specific ways, so ignore
            }
        }
    }
}
