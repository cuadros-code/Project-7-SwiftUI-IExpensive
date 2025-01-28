//
//  ExpensesViewSwiftData.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 26/01/25.
//

import SwiftUI
import SwiftData

struct ExpensesViewSwiftData: View {
    
    @Environment(\.modelContext) var modelContext
    @Query() var expenses: [ExpenseItemData]
    @Binding var isAllComplete: Bool
    @Binding var filterTypes: FilterTypes
    
    var currencyPreference = Locale.current.currency?.identifier ?? "USD"
    
    var total: Double {
        var totalAmount: Double = 0.0
        expenses.forEach { item in
            if filterTypes == .All {
                if item.isComplete == false {
                    totalAmount += item.amount
                }
            }
            
            if filterTypes == .Personal {
                if item.isComplete == false && item.type == "Personal" {
                    totalAmount += item.amount
                }
            }
            
            if filterTypes == .Business {
                if item.isComplete == false && item.type == "Business" {
                    totalAmount += item.amount
                }
            }
        }
        return totalAmount
    }
    
    var body: some View {
        if filterTypes == .All || filterTypes == .Personal {
            Section("Personal") {
                ForEach(expenses) { item in
                    if item.type == "Personal" {
                        ListItemSwiftData(item: item)
                    }
                }
                .onDelete(perform: removeItem)
                
            }
        }
        
        if filterTypes == .All || filterTypes == .Business {
            Section("Business") {
                ForEach(expenses) { item in
                    if item.type == "Business" {
                        ListItemSwiftData(item: item)
                    }
                }
                .onDelete(perform: removeItem)
            }
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
        .onChange(of: isAllComplete) { _ , newValue in
            if newValue {
                markComplete()
            }
        }
    }
    
    init(
        search: String,
        sortOrder: [SortDescriptor<ExpenseItemData>],
        isAllComplete: Binding<Bool>,
        filterType: Binding<FilterTypes>
    ){
        _expenses = Query(filter: #Predicate<ExpenseItemData> { item in
            if search.count == 0 {
                return true
            } else {
                return item.name.localizedStandardContains(search)
            }
        }, sort: sortOrder)
        
        _isAllComplete = isAllComplete
        _filterTypes = filterType
    }
    
    func removeItem(at offsets: IndexSet) {
        for offset in offsets {
            let item = expenses[offset]
            modelContext.delete(item)
        }
    }
    
    func markComplete(){
        expenses.forEach { item in
            item.isComplete = true
        }
    }
}

#Preview {
    ExpensesViewSwiftData(
        search: "",
        sortOrder: [],
        isAllComplete: .constant(false),
        filterType: .constant(.All)
    )
        .modelContainer(for: ExpenseItemData.self)
}
