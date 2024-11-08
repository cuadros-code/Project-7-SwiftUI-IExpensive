//
//  ListItem.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 7/11/24.
//

import SwiftUI

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
        
        expenses.items.sort{
            !$0.isComplete && $1.isComplete
        }
        
    }
    
}

#Preview {
    ListItem(
        item: ExpenseItem(
            name: "Test ",
            type: "Personal",
            amount: 1000.0,
            isComplete: false
        ),
        currencyPreference: "COP",
        expenses: Expenses()
    )
}
