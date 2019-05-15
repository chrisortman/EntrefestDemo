//
//  ListItemsController.swift
//  EntrefestDemo
//
//  Created by Ortman, Chris E on 5/14/19.
//  Copyright © 2019 Chris Ortman. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class ItemListController : UITableViewController {
    var FormController = ItemFormController.self
    
    private let realm = try! Realm()
    private var data : Results<Item>!
    private var notificationToken: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    private func setupData() {
        self.data = realm.objects(Item.self).sorted(byKeyPath: "createdAt", ascending: false)
        
        self.notificationToken?.invalidate()
        self.notificationToken = self.data.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                self.tableView.reloadData()
                break
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the TableView
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                self.tableView.endUpdates()
                break
            case .error(let err):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(err)")
                break            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ItemFormController {
            vc.finishCallback = { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = data[indexPath.row]
        
        var cell = self.tableView.dequeueReusableCell(withIdentifier: "ItemDisplay", for: indexPath) as! UITableViewCell
        
        cell.textLabel?.text = item.text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.data[indexPath.row]
        let controller = createFormController()
        controller.existingItem = item            
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    private func createFormController() -> ItemFormController {
        let controller = FormController.init()
        controller.finishCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        return controller
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = self.contextualDeleteAction(forRowAtIndexPath: indexPath)
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
    func contextualDeleteAction(forRowAtIndexPath indexPath : IndexPath) -> UIContextualAction {
        let record = data[indexPath.row]
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            
            self.realm.beginWrite()
            self.realm.delete(record)
            self.tableView.deleteRows(at: [indexPath], with: .none)
            try! self.realm.commitWrite(withoutNotifying: [self.notificationToken])
            completionHandler(true)
        }
        
        
        
        return action
    }
    
}
