import SwiftUI

struct SUIAlert: View {
    @State private var showView = false
    @State private var showAlert1 = false
    @State private var showAlert2 = false
    @State private var showConfirmation = false
    @State private var showActionSheet = false
    
    var body: some View {
        VStack {
            if showView {
                Text("Hidden view")
            }
            
            Button("Show alert 1", action: {
                self.showAlert1 = true
            })
            .alert(isPresented: $showAlert1) {
                Alert(
                    title: Text("Show view?"),
                    primaryButton: .default(Text("Yes")) {
                        self.showView = true
                    },
                    secondaryButton: .cancel(Text("No")) {
                        self.showView = false
                    }
                )
            }
            
            Button("Show alert 2", action: {
                self.showAlert2 = true
            })
            .alert(isPresented: $showAlert2) {
                Alert(
                    title: Text("Second Alert"),
                    message: Text("This is another alert."),
                    dismissButton: .default(Text("OK"))
                )
            }
            
            Button("Show Confirmation", action: {
                self.showConfirmation = true
            })
            .alert("Are you sure you want to continue?", isPresented: $showConfirmation) {
                Button("Delete", role: .destructive) {
                    print("delete")
                }
            }
            
            Button("Show Action Sheet", action: {
                self.showActionSheet = true
            })
            .actionSheet(isPresented: $showActionSheet) {
                ActionSheet(
                    title: Text("Options"),
                    message: Text("Choose an option"),
                    buttons: [
                        .default(Text("Option 1")) {
                            print("action 1")
                        },
                        .default(Text("Option 2")) {
                            print("action 2")
                        },
                        .cancel()
                    ]
                )
            }
        }
    }
}


#Preview {
    SUIAlert()
}
