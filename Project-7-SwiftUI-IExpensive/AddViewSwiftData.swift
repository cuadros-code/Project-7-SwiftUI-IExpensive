
//
//  AddView 2.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 25/01/25.
//


//
//  AddView.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 5/11/24.
//

import SwiftUI
import SwiftData

struct AddViewSwiftData: View {
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = 0.0
    
    @State private var navigationTitle = "Add title here..."
    
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(.red)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let item = ExpenseItemData(
                            name: name.count > 0
                                ? name
                                : navigationTitle,
                            type: type,
                            amount: amount,
                            isComplete: false
                        )
                        modelContext.insert(item)
                        dismiss()
                    }
                }
                
            }
            .navigationTitle($navigationTitle)
            .navigationBarBackButtonHidden()
        }
        
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: ExpensesData.self,
            configurations: config
        )
        let data = ExpenseItemData(name: "Milk", type: "Business", amount: 2.00, isComplete: false)
        return AddViewSwiftData()
            .modelContainer(container)
    } catch {
        return Text("Error")
    }
}
