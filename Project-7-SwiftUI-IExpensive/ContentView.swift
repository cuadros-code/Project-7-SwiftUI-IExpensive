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

struct ExpenseItem: Identifiable {
    let id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]()
}


struct ContentView: View {
    
    @State private var expenses = Expenses()
    
    var body: some View {
        NavigationStack {
         
            List {
                ForEach(expenses.items) { item in
                    Text(item.name)
                }
                .onDelete(perform: removeItem)
            }
            
            .navigationTitle("iExpenses")
            .toolbar {
                Button("Add Expenses", systemImage: "plus") {
                    let expense = ExpenseItem(name: "Test", type: "Persnal", amount: 12.00)
                    withAnimation {
                     expenses.items.append(expense)
                    }
                }
            }
        }
    }
    
    func removeItem(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
}

#Preview {
    ContentView()
}
