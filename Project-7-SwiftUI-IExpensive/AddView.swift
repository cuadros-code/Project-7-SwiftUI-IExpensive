//
//  AddView.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 5/11/24.
//

import SwiftUI

struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    var expenses: Expenses
    
    let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(types, id: \.self){
                        Text($0)
                    }
                }
                TextField("Amount", value: $amount, format: .currency(code: "COP"))
                    .keyboardType(.numberPad)
            }
            .navigationTitle("Add new expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Save") {
                    let item = ExpenseItem(
                        name: name,
                        type: type,
                        amount: amount,
                        isComplete: false
                    )
                    expenses.items.append(item)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    AddView(expenses: Expenses())
}
