//
//  MyTableViewController.swift
//  EntrefestDemo
//
//  Created by Ortman, Chris E on 5/9/19.
//  Copyright © 2019 Chris Ortman. All rights reserved.
//

import Foundation
import UIKit

class MyTableViewController : UITableViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var membershipLabel: UILabel!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        membershipLabel.text = "Adding"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ViewController {
        }
    }
}
