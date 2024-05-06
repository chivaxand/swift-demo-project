import SwiftUI

struct SUIBindObserved: View {
    @ObservedObject var userInfo = UserInfo(userId: 123, name: "Alex")
    @State private var isEditing = false
    
    var body: some View {
        VStack {
            Text("Name: \(userInfo.name)")
                .padding(8)
            
            Button("Edit", action: {
                isEditing = true
            })
            .padding(8)
            
            NavigationLink(
                destination: EditUserNameView2(name: $userInfo.name),
                label: {
                    Text("Edit")
                })
            .padding(8)
        }
        .sheet(isPresented: $isEditing) {
            EditUserNameView(name: $userInfo.name, isEditing: $isEditing)
        }
        .navigationBarTitle("Bind / Observed")
    }
}


fileprivate struct EditUserNameView: View {
    @Binding var name: String
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .padding(8)
                .frame(maxWidth: 300)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
            
            Button("Apply", action: {
                isEditing = false
            })
        }
    }
}


fileprivate struct EditUserNameView2: View {
    @Binding var name: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .padding(8)
                .frame(maxWidth: 300)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
            
            Button("Apply", action: {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}


#Preview {
    SUIBindObserved()
}
