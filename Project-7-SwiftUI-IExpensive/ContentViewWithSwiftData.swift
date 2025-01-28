//
//  ContentViewWithSwiftData.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 25/01/25.
//

import SwiftUI
import SwiftData

enum FilterTypes {
    case Personal
    case Business
    case All
}

struct ContentViewWithSwiftData: View {
    
    @State private var showingAddExpense = false
    @State private var markAllComplete = false
    @State private var textSearch = ""
    @State private var showingTextField = false
    
    @State private var filterTypes: FilterTypes = .All
    
    var currencyPreference = Locale.current.currency?.identifier ?? "USD"
    
    @State private var sort: [SortDescriptor] = [
        SortDescriptor(\ExpenseItemData.name),
        SortDescriptor(\ExpenseItemData.amount),
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        if showingTextField {
                            HStack {
                                TextField("Search", text: $textSearch)
                                Button {
                                    textSearch = ""
                                } label: {
                                    Image(systemName: "xmark.circle")
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    
                    Section {
                        Picker("", selection: $sort) {
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
                        .pickerStyle(.segmented)
                    }
                    .listRowBackground(Color.clear)
                    .listSectionSpacing(0.0)
                    
                    ExpensesViewSwiftData(
                        search: textSearch,
                        sortOrder: sort,
                        isAllComplete: $markAllComplete,
                        filterType: $filterTypes
                    )
                }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 15)
                    .onChanged { value in
                        withAnimation {
                            if value.translation.height > 50 {
                                showingTextField = true
                            }
                        }
                    }
            )
            
            .navigationTitle("iExpenses")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        EditButton()
                        Button("Mark all") {
                            markAllComplete.toggle()
                        }
                    } label: {
                        Text("Menu")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("Filter", systemImage: "line.3.horizontal.decrease") {
                        Picker("Filter", selection: $filterTypes) {
                            Text("All")
                                .tag(FilterTypes.All)
                            Text("Filter Personal")
                                .tag(FilterTypes.Personal)
                            Text("Fiter Business")
                                .tag(FilterTypes.Business)
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
    
}

#Preview {
    ContentViewWithSwiftData()
}
