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
                    EditButton()
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
    
}

struct ListItem: View {
    var item: ExpenseItem
    var currencyPreference = Locale.current.currency?.identifier ?? "USD"
    var expenses: Expenses
    
    var body: some View {
        HStack {
            if item.isComplete {
                Image(systemName: "checkmark.seal.fill")
                    .foregroundStyle(.green)
                    .animation(.bouncy, value: item.isComplete)
            }
            
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
                    .font(.subheadline)
            }
            Spacer()
            PriceItem(price: item.amount)
                .strikethrough(item.isComplete, color: .black)
        }
        .contextMenu {
            Button(role: .destructive) {
                expenses.items.removeAll(where: { $0.id == item.id })
            } label: {
                Text("Delete")
                Image(systemName: "trash")
            }
            Button {
                toggleCompleteItem()
            } label: {
                Text("Mark \(item.isComplete ? "incomplete" : "complete")")
                Image(systemName: "checkmark.circle")
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleCompleteItem()
        }
    }
    
    
    func toggleCompleteItem() {
        if let index = expenses.items.firstIndex(where: { $0.id == item.id }) {
            withAnimation{
                expenses.items[index].isComplete.toggle()
            }
        }
    }
    
}

struct PriceItem: View {
    var price: Double
    var currencyPreference = Locale.current.currency?.identifier ?? "USD"
    
    var body: some View {
        Text(price, format: .currency(code: currencyPreference))
            .fontWeight(.bold)
            .foregroundStyle(
                price < 50000 ? .green : price < 100000 ? .blue : .purple
            )
    }
}

#Preview {
    ContentView()
}
