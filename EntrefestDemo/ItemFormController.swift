//
//  ItemFormController.swift
//  EntrefestDemo
//
//  Created by Ortman, Chris E on 5/14/19.
//  Copyright © 2019 Chris Ortman. All rights reserved.
//

import Foundation
import Eureka
import PKHUD
import RealmSwift
import AVFoundation

class ItemFormController : FormViewController {
    
    var feedbackGenerator = UINotificationFeedbackGenerator()
    var existingItem : Item?
    var finishCallback : (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section()
        <<< TextRow("TextField") { tr in
            tr.title = "Text"
            tr.placeholder = "item text"
            tr.value = self.existingItem?.text
            tr.add(rule: RuleRequired(msg: "Text is required"))
            tr.validationOptions = .validatesOnChangeAfterBlurred
        }.cellUpdate { (cell,row) in
            if !row.isValid {
                cell.titleLabel?.textColor = .red
            }
        }
        +++ Section()
        <<< ButtonRow("SaveButton") {
            $0.title = "Save"
        }.onCellSelection { (cell,row) in
            
            let errors = self.form.validate()
            guard errors.isEmpty else {
                self.showValidationErrors(errors: errors)
                return
            }
            
            let realm = try! self.existingItem?.realm ?? Realm()
            realm.beginWrite()
            
            if let model = self.existingItem {
                model.updateFrom(itemForm: self.form.values())
            } else {
                let model = Item()
                realm.add(model)
                model.updateFrom(itemForm: self.form.values())
            }
            
            try! realm.commitWrite()
            
            
             self.closeWithMode()
//            self.giveSuccessFeedback()
//            HUD.flash(.success, delay: 1.0) { finished in
//               
//            }
        }
    }

    private func showValidationErrors(errors: [ValidationError]) {
        let messages = errors.map { $0.msg }.joined()
        
        let alertController = UIAlertController(title: "Please correct the following errors", message: messages, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func giveSuccessFeedback() {
        self.feedbackGenerator.notificationOccurred(UINotificationFeedbackGenerator.FeedbackType.success)
        AudioServicesPlayAlertSound(SystemSoundID(1001))
    }
    
    private func closeWithMode() {
        
        if let cb = self.finishCallback {
            cb()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
