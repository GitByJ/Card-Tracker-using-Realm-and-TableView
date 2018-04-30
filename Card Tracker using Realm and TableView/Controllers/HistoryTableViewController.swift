//
//  HistoryTableViewController.swift
//  Card Tracker using Realm and TableView
//
//  Created by Jae-Jun Shin on 25/04/2018.
//  Copyright © 2018 Jae-Jun Shin. All rights reserved.
//

import UIKit
import RealmSwift

class HistoryTableViewController: UITableViewController {
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadHistory()
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return amountContainer?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = amountContainer?[indexPath.row].howMuchYouSpend ?? "No history added yet."
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = amountContainer?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(item)
                }
            } catch {
                print("Error, \(error)")
            }
        }
        
        tableView.reloadData()
        
    }
    
    func loadHistory() {
        amountContainer = realm.objects(Amount.self)
        
        tableView.reloadData()
    }

    
    
 

}
