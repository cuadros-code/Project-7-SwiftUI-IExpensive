//
//  ContentViewWithSwiftData.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 25/01/25.
//

import SwiftUI
import SwiftData

struct ContentViewWithSwiftData: View {
    
    @Environment(\.modelContext) var modelContext
    @State private var showingAddExpense = false
    
    var currencyPreference = Locale.current.currency?.identifier ?? "USD"
    
    @State private var sort: [SortDescriptor] = [
        SortDescriptor(\ExpenseItemData.amount),
        SortDescriptor(\ExpenseItemData.name),
    ]
    
    
    var body: some View {
        NavigationStack(){
            ExpensesViewSwiftData(sortOrder: sort)
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
                    Menu("Sort", systemImage: "arrow.up.arrow.down") {
                        Picker("Sort", selection: $sort) {
                            Text("Sort by Name")
                                .tag([
                                    SortDescriptor(\ExpenseItemData.name),
                                    SortDescriptor(\ExpenseItemData.amount),
                                ])
                            
                            Text("Sort by Amount")
                                .tag([
                                    SortDescriptor(\ExpenseItemData.amount),
                                    SortDescriptor(\ExpenseItemData.name)
                                ])
                        }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Add") {
                        AddViewSwiftData()
                    }
                }
            } // toolbar
        }
    }
    
    func markComplete(){
//        expenses.forEach { item in
//            item.isComplete = true
//        }
    }
}

#Preview {
    ContentViewWithSwiftData()
}
