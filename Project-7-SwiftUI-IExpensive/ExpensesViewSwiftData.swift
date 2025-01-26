//
//  ExpensesViewSwiftData.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 26/01/25.
//

import SwiftUI
import SwiftData

struct ExpensesViewSwiftData: View {
    
    @Environment(\.modelContext) var modelContext
    @Query() var expenses: [ExpenseItemData]
    
    var currencyPreference = Locale.current.currency?.identifier ?? "USD"
    
    var total: Double {
        var totalAmount: Double = 0.0
        expenses.forEach { item in
            if item.isComplete == false {
                totalAmount += item.amount
            }
        }
        return totalAmount
    }
    
    var body: some View {
        List {
            Section("Personal") {
                ForEach(expenses) { item in
                    if item.type == "Personal" {
                        ListItemSwiftData(item: item)
                    }
                }
                .onDelete(perform: removeItem)
                
            }
            
            Section("Business") {
                ForEach(expenses) { item in
                    if item.type == "Business" {
                        ListItemSwiftData(item: item)
                    }
                }
                .onDelete(perform: removeItem)
            }
            
            Section {
                HStack {
                    Text("Total")
                        .font(.headline)
                    Spacer()
                    Text(
                        total,
                        format: .currency(code: currencyPreference)
                    )
                    .fontWeight(.bold)
                }
            }
        }
    }
    
    init(sortOrder: [SortDescriptor<ExpenseItemData>]){
        _expenses = Query(sort: sortOrder)
    }
    
    func removeItem(at offsets: IndexSet) {
        for offset in offsets {
            let item = expenses[offset]
            modelContext.delete(item)
        }
    }
    
    func markComplete(){
        expenses.forEach { item in
            item.isComplete = true
        }
    }
}

#Preview {
    ExpensesViewSwiftData(sortOrder: [])
        .modelContainer(for: ExpenseItemData.self)
}
