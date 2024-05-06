import SwiftUI

struct SUIGradient: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                RadialGradient(stops: [
                    .init(color: .cyan, location: 0.3),
                    .init(color: .blue, location: 0.5)
                ], center: .center, startRadius: 10, endRadius: 50)
                .frame(height: 100)
                
                RadialGradient(gradient: Gradient(colors: [.cyan, .blue]),
                               center: .center,
                               startRadius: 10,
                               endRadius: 50)
                .frame(height: 100)
                
                LinearGradient(colors: [.blue, .green],
                               startPoint: .topLeading,
                               endPoint: .bottomTrailing)
                .frame(height: 200)
            }
        }
    }
}

#Preview {
    SUIGradient()
}
