import SwiftUI

struct PreferenceKeyDemo: View {
    @State var title: String = "none"
    @State var offset: CGPoint = .zero
    
    var body: some View {
        ScrollView {
            VStack {
                Text(title)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .opacity(offset.y / 60.0)
                    .foregroundColor(
                        // Double(min(max(offset.y, 0), 120)) / 120.0)
                        Color(UIColor.black.interpolate(to: UIColor.red,
                                                        progress: offset.y.getProgress(from: 50, to: 120)))
                    )
                    .background(
                        GeometryReader { g in
                            Text("").preference(key: ScrollViewOffsetPreferenceKey.self,
                                                value: g.frame(in: .global).origin)
                        }
                    )
                
                SubviewContainer()
                
                Divider()
                
                ForEach(0..<30) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.blue)
                        .frame(height: 50)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    
                }
            }
            .onPreferenceChange(CustomTitlePreferenceKey.self) { title in
                if let title {
                    self.title = title
                }
            }
        }
        .overlay(alignment: .top) {
            Text(title)
                .font(.largeTitle)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.yellow)
                .opacity(offset.y < 10 ? 1 : 0)
            
        }
        .overlay(alignment: .bottom) {
            Text("Offset: \(String(format: "%.1f", offset.y))")
                .frame(maxWidth: .infinity)
                .background(.white)
        }
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
            self.offset = value
        }
    }
    
    
    struct SubviewContainer: View {
        @State var title: String? = nil
        
        var body: some View {
            Text("Subview Content")
                .background(Color.green)
                .onAppear(perform: loadTitleData)
                .preference(key: CustomTitlePreferenceKey.self, value: title)
        }
        
        func loadTitleData() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.title = "Title"
            }
        }
    }


    struct CustomTitlePreferenceKey: PreferenceKey {
        typealias Value = String?
        static var defaultValue: String? = nil
        static func reduce(value: inout String?, nextValue: () -> String?) {
            value = value ?? nextValue()
        }
    }
    
    struct ScrollViewOffsetPreferenceKey: PreferenceKey {
        typealias Value = CGPoint
        static var defaultValue: CGPoint = .zero
        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
            value = nextValue()
        }
    }
}


#Preview {
    PreferenceKeyDemo()
}
