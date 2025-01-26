//
//  ListItem 2.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 25/01/25.
//
//
//  ListItem.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 7/11/24.
//

import SwiftUI

struct ListItemSwiftData: View {
    
    @Environment(\.modelContext) var modelContext
    @Bindable var item: ExpenseItemData
    var currencyPreference = Locale.current.currency?.identifier ?? "USD"
    
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
                modelContext.delete(item)
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
        item.isComplete.toggle()
    }
    
}

#Preview {
    ListItemSwiftData(
        item: ExpenseItemData(
            name: "Test ",
            type: "Personal",
            amount: 1000.0,
            isComplete: false
        ),
        currencyPreference: "COP"
    )
}
