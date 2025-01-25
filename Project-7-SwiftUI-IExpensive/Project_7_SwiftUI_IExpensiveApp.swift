//
//  Project_7_SwiftUI_IExpensiveApp.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 4/11/24.
//

import SwiftUI
import SwiftData

@main
struct Project_7_SwiftUI_IExpensiveApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
            ContentViewWithSwiftData()
        }.modelContainer(for: ExpenseItemData.self)
        
    }
}
