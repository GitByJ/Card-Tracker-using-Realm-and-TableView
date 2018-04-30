//
//  Amount.swift
//  Card Tracker using Realm and TableView
//
//  Created by Jae-Jun Shin on 25/04/2018.
//  Copyright © 2018 Jae-Jun Shin. All rights reserved.
//

import Foundation
import RealmSwift

class Amount: Object, Codable {
    
    var totalAmount: Int = 1000000
    @objc dynamic var howMuchYouSpend: String = ""
    
}
