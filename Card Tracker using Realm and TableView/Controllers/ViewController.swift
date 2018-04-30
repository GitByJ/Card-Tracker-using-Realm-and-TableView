//
//  ViewController.swift
//  Card Tracker using Realm and TableView
//
//  Created by Jae-Jun Shin on 25/04/2018.
//  Copyright © 2018 Jae-Jun Shin. All rights reserved.
//

import UIKit
import RealmSwift

var amountContainer: Results<Amount>?


class ViewController: UIViewController {
    
    let realm = try! Realm()
    
    var amountArray = [Amount]()
    let newAmount = Amount()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("newTracker.plist")
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var moneyTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadRealm()
        
        print(dataFilePath)
        
        amountArray.append(newAmount)
        
        load()
        
        let checkLeftAmount = amountArray[0]
        totalLabel.text = "₩\(checkLeftAmount.totalAmount)"
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func spendButtonPressed(_ sender: UIButton) {
        
        
        if (moneyTextField.text?.isEmpty)! {
            print("Enter an amount you've spent")
            
            let alert = UIAlertController(title: "Enter how much you spent.", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
        } else {
            popUp()
            
        }
        
    }
    
    @IBAction func manButtonPressed(_ sender: UIButton) {
        puttingMoneyAmount(howMuch: 10000)
    }
    
    @IBAction func cheonButtonPressed(_ sender: UIButton) {
        puttingMoneyAmount(howMuch: 1000)
    }
    
    @IBAction func beakButtonPressed(_ sender: UIButton) {
        puttingMoneyAmount(howMuch: 100)
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
        let valueInArray = amountArray[0]
        valueInArray.totalAmount = 1000000
        totalLabel.text = "₩\(valueInArray.totalAmount)"
        
        save()
        
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error reseting, \(error)")
        }
        
        view.reloadInputViews()
        
    }
    
    @IBAction func undoButtonPressed(_ sender: UIButton) {
        
        let valueInArray = amountArray[0]
        
        if (moneyTextField.text?.isEmpty)! {
            print("Enter an amount you've spent")
            
            let alert = UIAlertController(title: "Enter how much you spent.", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
            
        } else {
            valueInArray.totalAmount += Int(moneyTextField.text!)!
            totalLabel.text = "₩\(valueInArray.totalAmount)"
            save()
            
            do {
                try realm.write {
                    let element = Amount()
                    element.howMuchYouSpend = "Undo" + " " + moneyTextField.text!
                    
                    realm.add(element)
                }
            } catch {
                print("Error deleting value, \(error)")
            }
            
        }
        
        view.reloadInputViews()

    }
    
    func save() {
        
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(amountArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding, \(error)")
        }
        view.reloadInputViews()
        
    }
    
    func load() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                amountArray = try decoder.decode([Amount].self, from: data)
            } catch {
                print("Error decoding \(error)")
            }
        }
        
    }
    
    func puttingMoneyAmount(howMuch: Int) {
        
        if (moneyTextField.text?.isEmpty)! {
            moneyTextField.text = String(howMuch)
        } else {
            let addedAmount = Int(moneyTextField.text!)! + howMuch
            moneyTextField.text = String(addedAmount)
        }
        
    }
    
    func popUp() {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "History", message: "Put a name on it.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Done", style: .default) { (action) in
            
            do {
                try self.realm.write {
                    let element = Amount()
                    element.howMuchYouSpend = textField.text! + " " + self.moneyTextField.text!
                    
                    self.realm.add(element)
                    
                    self.view.reloadInputViews()
                }
            } catch {
                print("Error storing value, \(error)")
            }
            
            let valueInArray = self.amountArray[0]
            valueInArray.totalAmount -= Int(self.moneyTextField.text!)!
            self.save()
            self.totalLabel.text = "₩\(valueInArray.totalAmount)"
            
            self.view.endEditing(true)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (action) in
            
            self.view.endEditing(true)
            
        }
        
        alert.addAction(action)
        alert.addAction(cancel)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new history"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func loadRealm() {
        amountContainer = realm.objects(Amount.self)
    }


}
