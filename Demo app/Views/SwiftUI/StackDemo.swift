import SwiftUI

struct StackDemo: View {
    @State private var selection: Int = 1
    
    var body: some View {
        ScrollView {
            HStack(alignment: .center, spacing: 10) {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                
                Text("X")
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50, alignment: .center)
                    .background(Color.green)
                    .offset(x:  0, y: -12)
                    .padding(.trailing, 20)
                    .background(Color.green.opacity(0.2))
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 25, height: 25)
            }
            .border(Color.gray)
            Divider().padding(.vertical, 10)
            
            
            VStack(alignment: .center, spacing: 10) {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 50, height: 50)
                    .alignmentGuide(HorizontalAlignment.center, computeValue: { d in
                        d[HorizontalAlignment.center] - 15
                    })
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 25, height: 25)
            }
            .border(Color.gray)
            Divider().padding(.vertical, 10)
            
            
            ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                
                Rectangle()
                    .fill(Color.green)
                    .frame(width: 30, height: 30)
                    .alignmentGuide(HorizontalAlignment.leading, computeValue: { d in
                        -d[HorizontalAlignment.trailing]
                    })
                    .border(.black)
                
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 20)
                
                Rectangle()
                    .fill(Color.yellow)
                    .frame(width: 10, height: 10)
                    .offset(x: 0, y: 10)
            }
            .border(Color.gray)
            Divider().padding(.vertical, 10)
            
            
            Rectangle()
                .fill(Color.red)
                .frame(width: 100, height: 100)
                .overlay(alignment: .topLeading) {
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 30, height: 30)
                        .offset(x: 0, y: 0)
                }
                .overlay(alignment: .topTrailing) {
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 30, height: 30)
                        .offset(x: 0, y: 0)
                }
                .overlay(alignment: .bottomLeading) {
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 30, height: 30)
                        .offset(x: 0, y: 0)
                }
                .overlay(alignment: .bottomTrailing) {
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: 30, height: 30)
                        .offset(x: 0, y: 0)
                }
            Divider().padding(.vertical, 10)
            
            
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 100, height: 100)
                
                GeometryReader { geometry in
                    Path { path in
                        path.move(to: CGPoint(x: 1, y: 1))
                        path.addLine(to: CGPoint(x: geometry.size.width - 1, 
                                                 y: geometry.size.height - 1))
                    }
                    .stroke(lineWidth: 2)
                    .fill(Color.orange)
                    
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 30, height: 30)
                        .offset(x: 0, y: 0)
                    
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 30, height: 30)
                        .offset(x: geometry.size.width - 30, y: 0)
                    
                    Rectangle()
                        .fill(Color.yellow)
                        .frame(width: 30, height: 30)
                        .offset(x: 0, y: geometry.size.height - 30)
                    
                    Rectangle()
                        .fill(Color.orange)
                        .frame(width: 30, height: 30)
                        .offset(x: geometry.size.width - 30, y: geometry.size.height - 30)
                }
                .border(Color.gray)
            }
            .frame(width: 200, height: 200)
            Divider().padding(.vertical, 10)
            
            
            Picker("Menu", selection: $selection) {
                Text("Item 1")
                Text("Item 2")
                Text("Item 3")
            }
            .pickerStyle(.menu)
        }
    }
}


extension VerticalAlignment {
    private enum MyVerticalAlignment : AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[.top]
        }
    }
    static let myVerticalAlignment = VerticalAlignment(MyVerticalAlignment.self)
}

extension HorizontalAlignment {
    private enum MyHorizontalAlignment : AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[.leading]
        }
    }
    static let myHorizontalAlignment = HorizontalAlignment(MyHorizontalAlignment.self)
}

extension Alignment {
    static let myAlignment = Alignment(horizontal: .myHorizontalAlignment, 
                                       vertical: .myVerticalAlignment)
}


#Preview {
    StackDemo()
}
