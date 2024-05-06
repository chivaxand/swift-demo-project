import SwiftUI

struct ParallaxEffect: View {
    let range1: (CGFloat, CGFloat) = (0, -100)
    let headerSize: CGFloat = 200
    let titleHeight: CGFloat = 60

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 0) {
                        GeometryReader { g in
                            ZStack(alignment: .bottom) {
                                Color.clear
                                    .frame(width: geometry.size.width,
                                           height: max(titleHeight, headerSize
                                                       * (1 - getProgress(in: g, range: range1))))
                                
//                                Color.clear
//                                    .onChange(of: g.frame(in: .global).minY) { newValue in
//                                        print("onChange: \(newValue)")
//                                    }
                                
                                Image("avatar1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geometry.size.width, height: headerSize)//,                                           height: headerSize * (1 - getProgress(in: g, range: range1)))
                                    .offset(y: -headerSize * getProgress(in: g, range: range1))
                                    .clipped()
                                
                                Text("Title")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .padding()
                                    .background(Color.white.opacity(0.7))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .frame(height: self.titleHeight)
                                    .offset(y: g.frame(in: .global).minY < -100 ? -100-g.frame(in: .global).minY : 0)
                            }
                        }
                        .frame(height: headerSize)
                        
                        ForEach(0..<20) { index in
                            Text("Item \(index)")
                                .padding()
                        }
                    }
                }
                
            }

        }
        .edgesIgnoringSafeArea(.all)
    }
    
    private func getProgress(forOffset offset: CGFloat, range: (CGFloat, CGFloat)) -> CGFloat {
        let minY = range1.0 < range1.1 ? range1.0 : range1.1
        let maxY = range1.0 < range1.1 ? range1.1 : range1.0
        let progress = min(max((offset - minY) / (maxY - minY), 0), 1)
        print(offset, progress)
        return progress
    }
    
    private func getProgress(in geometry: GeometryProxy, range: (CGFloat, CGFloat)) -> CGFloat {
        let offset = geometry.frame(in: .global).minY
        let minY = range.0
        let maxY = range.1
        let progress = min(max((offset - minY) / (maxY - minY), 0), 1)
        print(offset, progress)
        return progress
    }
}

#Preview {
    ParallaxEffect()
}
