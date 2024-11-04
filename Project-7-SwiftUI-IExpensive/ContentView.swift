//
//  ContentView.swift
//  Project-7-SwiftUI-IExpensive
//
//  Created by Kevin Cuadros on 4/11/24.
//
import SwiftUI


struct User: Codable {
    let firstName: String
    let lastName : String
}


struct ContentView: View {
    
//    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
    
    @AppStorage("tapCount") private var tapCount = 0
    
    @State private var user = User(firstName: "Taylor", lastName: "Swift")
    
    var body: some View {
        VStack {
           
            Button("Tap Count: \(tapCount)") {
                tapCount += 1
//                UserDefaults.standard.set(tapCount, forKey: "Tap")
                
                let encoder = JSONEncoder()

                if let data = try? encoder.encode(user) {
                    UserDefaults.standard.set(data, forKey: "UserData")
                }
                
            }
        }
        
    }
    
}

#Preview {
    ContentView()
}
