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
    let name: String
    let type: String
    let amount: Double
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
                total += item.amount
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
    
    var body: some View {
        NavigationStack {
         
            List {
                Section {
                    ForEach(expenses.items) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                                    .font(.subheadline)
                            }
                            Spacer()
                            Text(item.amount, format: .currency(code: "COP"))
                        }
                    }
                    .onDelete(perform: removeItem)
                }
                
                Section {
                    HStack {
                        Text("Total")
                            .font(.headline)
                        Spacer()
                        Text(expenses.total, format: .currency(code: "COP"))
                    }
                }
            }
            
            
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)
            }
            
            .navigationTitle("iExpenses")
            .toolbar {
                Button("Add Expenses", systemImage: "plus") {
                    showingAddExpense.toggle()
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
