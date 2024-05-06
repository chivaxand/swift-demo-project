import SwiftUI

struct SUIEnvironment: View {
    @Environment(\.navigationController) private var navigationController
    @EnvironmentObject private var userInfo: UserInfo
    
    @State private var editedName: String = ""
    @State private var isEditing: Bool = false
    
    var body: some View {
        VStack {
            if !isEditing {
                Text("Name: \(userInfo.name)")
                Button("Edit", action: {
                    editedName = userInfo.name
                    isEditing = true
                })
                .padding(8)
            } else {
                TextField("Name", text: $editedName)
                    .padding(8)
                    .frame(maxWidth: 300)
                    .disabled(!isEditing)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                Button("Apply", action: {
                    userInfo.name = editedName
                    isEditing = false
                })
                .padding(8)
                .disabled(!isEditing)
            }
            
            Button("Random name") {
                userInfo.setRandomName()
            }
            
            Button("Go back") {
                if let nav = navigationController {
                    print("navigation")
                    nav.popViewController(animated: true)
                } else {
                    print("object is nil")
                }
            }
        }
        .onAppear {
            editedName = userInfo.name
        }
    }
}


struct NavigationEnvironmentKey: EnvironmentKey {
    static let defaultValue: UINavigationController? = nil
}

extension EnvironmentValues {
    var navigationController: UINavigationController? {
        get {
            let value = self[NavigationEnvironmentKey.self]
            //print("get env `navigationController` \(String(describing: value))")
            return value
        }
        set {
            //print("set env `navigationController` \(String(describing: newValue))")
            self[NavigationEnvironmentKey.self] = newValue
        }
    }
}


#Preview {
    let userInfo = UserInfo(userId: 123, name: "Ben Alex")
    return SUIEnvironment().environmentObject(userInfo)
}
