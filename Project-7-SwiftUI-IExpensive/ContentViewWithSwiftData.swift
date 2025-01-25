//
//  ContentViewWithSwiftData.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 25/01/25.
//

import SwiftUI
import SwiftData

struct ContentViewWithSwiftData: View {
    
    @Query() var expenses: [ExpenseItemData]
    
    @State private var showingAddExpense = false
    
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
        NavigationStack(){
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
            .navigationTitle("iExpenses")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        EditButton()
                        Button("Mark all", action: markComplete)
                    } label: {
                        Text("Menu")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Add") {
                        AddViewSwiftData()
                    }
                    
                }
            }
        }
    }
    
    func removeItem(at offsets: IndexSet) {
//        expenses.items.remove(atOffsets: offsets)
    }
    
    func markComplete(){
        expenses.forEach { item in
            item.isComplete = true
        }
    }
}

#Preview {
    ContentViewWithSwiftData()
}
