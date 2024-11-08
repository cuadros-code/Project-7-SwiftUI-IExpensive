//
//  ContentView.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 4/11/24.
//
import SwiftUI

// If the struct has an Identifiable protocol
// the id in ForEach is not required

// We has this
// ForEach(expenses.items, id: \.id) { item in
//    Text(item.name)
// }

// To his
// ForEach(expenses.items) { item in
//    Text(item.name)
// }

struct ExpenseItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var type: String
    var amount: Double
    var isComplete: Bool
}

@Observable
class Expenses {
    var total = 0.0
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
            total = 0.0
            items.forEach { item in
                if item.isComplete == false {
                    total += item.amount
                }
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodeItems = try? JSONDecoder().decode(
                [ExpenseItem].self,
                from: savedItems
            ) {
                items = decodeItems
                return
            }
        }
        items = []
    }
    
}


struct ContentView: View {
    @State private var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var currencyPreference = Locale.current.currency?.identifier ?? "USD"
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.items) { item in
                        if item.type == "Personal" {
                            ListItem(item: item, expenses: expenses)
                        }
                    }
                    .onDelete(perform: removeItem)
                    
                }
                
                Section("Business") {
                    ForEach(expenses.items) { item in
                        if item.type == "Business" {
                            ListItem(item: item, expenses: expenses)
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
                            expenses.total,
                            format: .currency(code: currencyPreference)
                        )
                        .fontWeight(.bold)
                    }
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
            
            .navigationTitle("iExpenses")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        EditButton()
                        Button("Select", action: markComplete)
                    } label: {
                        Text("Menu")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Expenses", systemImage: "plus") {
                        showingAddExpense.toggle()
                    }
                }
            }
            
        }
    }
    
    func removeItem(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func markComplete(){
        expenses.items = expenses.items.map { item in
            var modifiedItem = item
            modifiedItem.isComplete = true
            return modifiedItem
        }
    }
    
}

#Preview {
    ContentView()
}
