//
//  ExpenseModel.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 25/01/25.
//

import Foundation
import SwiftData

@Model
class ExpenseItemData {
    var id = UUID()
    var name: String
    var type: String
    var amount: Double
    var isComplete: Bool
    
    init(
        id: UUID = UUID(),
        name: String,
        type: String,
        amount: Double,
        isComplete: Bool
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.amount = amount
        self.isComplete = isComplete
    }
}


@Model
class ExpensesData {
    var total = 0.0
    var items = [ExpenseItem]() {
        didSet {
            total = 0.0
            
            items.forEach { item in
                if item.isComplete == false {
                    total += item.amount
                }
            }
        }
    }
    
    init(total: Double = 0.0, items: [ExpenseItem] = [ExpenseItem]()) {
        self.total = total
        self.items = items
    }
    
//    {
//        This is not required when implement SwiftData
//           |
//           V
//        didSet {
//            if let encoded = try? JSONEncoder().encode(items) {
//                UserDefaults.standard.set(encoded, forKey: "Items")
//            }
//            total = 0.0
//            items.forEach { item in
//                if item.isComplete == false {
//                    total += item.amount
//                }
//            }
//        }
//    }
    
//        This is not required when implement SwiftData
//           |
//           V
//    init() {
//        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
//            if let decodeItems = try? JSONDecoder().decode(
//                [ExpenseItem].self,
//                from: savedItems
//            ) {
//                items = decodeItems
//                return
//            }
//        }
//        items = []
//    }
    
}
