//
//  transactions.swift
//  ExpenceTracker
//
//  Created by Hasnain Khan on 4/26/18.
//  Copyright © 2018 Hasnain Khan. All rights reserved.
//

import Foundation

class Transactions {
    var type: String
    var date: Date
    var amount: Double
    var transID : String?
    
    init() {
        type = ""
        date = Date()
        amount = 0.0
    }
}
