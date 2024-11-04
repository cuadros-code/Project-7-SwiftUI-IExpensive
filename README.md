#  IExpensive

```swift
import SwiftUI

@Observable
class User {
    var name = "Kevin"
    var lastName = "Cuadros"
}

struct SecondView: View {
    @Environment(\.dismiss) var dismiss
    let name: String
    
    var body: some View {
        Text("Hello, \(name)!")
        Button("Dismiss"){
            dismiss()
        }
    }
}

struct ContentView: View {
    
    @State private var user = User()
    @State private var showingSheet = false
    
    var body: some View {
    
        VStack {
            Text("Your name is \(user.name) \(user.lastName)")
            
            TextField("First name", text: $user.name)
            TextField("Last name", text: $user.lastName)
            
            Button("Show Sheet") {
                showingSheet.toggle()
            }
            
            .sheet(isPresented: $showingSheet) {
                SecondView(name: user.name)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
