import SwiftUI

struct GeometryReaderView: View {
    let range1: (CGFloat, CGFloat) = (0, -100)
    let headerSize: CGFloat = 200
    let titleHeight: CGFloat = 60
    
    var body: some View {
        VStack {
            
            NavigationLink("ScrollView reader") {
                ScrollViewReaderDemo()
            }
            
            NavigationLink("Item transform demo") {
                ItemTransformDemo()
            }
            
        }
    }
    
    
    struct ScrollViewReaderDemo : View {
        @State var scrollToIndex: Int = 0
        @State var itemIndexText: String = "20"
        
        var body: some View {
            VStack {
                
                TextField("Item index", text: $itemIndexText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .border(Color.gray)
                    .keyboardType(.numberPad)
                    .padding()
                
                Button("Scroll to item") {
                    withAnimation(.spring()) {
                        if let index = Int(itemIndexText) {
                            scrollToIndex = index
                        }
                    }
                }
                
                ScrollView {
                    ScrollViewReader { proxy in
                        ForEach(0..<50) { index in
                            Text("Test text \(index)")
                                .font(.headline)
                                .frame(height: 100)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                                .padding()
                                .id(index)
                        }
                        .onChange(of: scrollToIndex) { value in
                            withAnimation(.spring) {
                                proxy.scrollTo(value, anchor: .center)
                            }
                        }
                    }
                }
            }
        }
    }
    
    struct ItemTransformDemo: View {
        var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0..<20) { index in
                        GeometryReader { geometry in
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.blue)
                                .rotation3DEffect(
                                    Angle(degrees: getPercentage(geometry) * 40),
                                    axis: (x: 0.0, y: 1.0, 0.0))
                        }
                        .frame(width: 200, height: 200)
                        .padding()
                    }
                }
            }
        }
        
        func getPercentage(_ g: GeometryProxy) -> Double {
            let maxDistance = UIScreen.main.bounds.width / 2
            let currentX = g.frame(in: .global).midX
            return Double(1 - (currentX / maxDistance))
        }
    }
}

#Preview {
    NavigationStack {
        GeometryReaderView()
    }
}
