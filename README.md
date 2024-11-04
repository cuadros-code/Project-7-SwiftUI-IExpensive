#  IExpensive

## Sharing SwiftUI state with @Observable

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
```


## Deleting items using onDelete()

```swift 
import SwiftUI


struct ContentView: View {
    
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(numbers, id: \.self)  {
                        Text("Row \($0)")
                    }
                    .onDelete(perform: removeRows)
                }
                
                Button("Add number") {
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
                
            }
            .toolbar {
                EditButton()
            }
        }
    }
    
    func removeRows(at offsets: IndexSet){
        numbers.remove(atOffsets: offsets)
    }
    
}

#Preview {
    ContentView()
}
```
