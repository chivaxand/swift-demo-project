import SwiftUI


struct SUIComponents: View {
    @State private var toggle1 = false
    @State private var toggle2 = false
    @State private var toggle3 = false
    
    @State private var brightnessValue = 0.3

    var body: some View {
        List {
            Toggle("Wi-Fi", systemImage: toggle1 ? "wifi" : "wifi.slash", isOn: $toggle1)
                .tint(.purple)
            Toggle("Wi-Fi", systemImage: toggle2 ? "wifi" : "wifi.slash", isOn: $toggle2)
                .toggleStyle(.button)
                .contentTransition(.opacity)
            Toggle("Wi-Fi", systemImage: toggle3 ? "wifi" : "wifi.slash", isOn: $toggle3)
                .toggleStyle(.button)
                .labelStyle(.iconOnly)
                .contentTransition(.opacity)
            
            // Slider
            Image(systemName: "sun.max.fill")
                .font(.system(size: 50))
                .foregroundColor(.yellow)
                .opacity(brightnessValue)
            Slider(value: $brightnessValue, in: 0...1)
                .padding()
            
            // UIView
            CustomView()
        }
    }
    
    struct CustomView: UIViewRepresentable {
        typealias UIViewType = CustomUIView
        func makeUIView(context: Context) -> CustomUIView {
            let customView = CustomUIView()
            customView.backgroundColor = .clear
            return customView
        }
        func updateUIView(_ uiView: CustomUIView, context: Context) {
            print("Update view: \(uiView)")
        }
    }

    class CustomUIView: UIView {
        var borderWidth: CGFloat = 4.0 { didSet { setNeedsDisplay() } }
        override func draw(_ rect: CGRect) {
            let width = self.borderWidth
            let center = CGPoint(x: rect.midX, y: rect.midY)
            let radius = min(rect.width, rect.height) / 2 - width / 2
            let circlePath = UIBezierPath(arcCenter: center, radius: radius,
                                          startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
            UIColor.orange.setFill()
            circlePath.fill()
            UIColor.blue.setStroke()
            circlePath.lineWidth = width
            circlePath.stroke()
        }
    }
}




// https://github.com/splinetool/spline-ios
// import SplineRuntime
/*
 let url = URL(string: "https://build.spline.design/tVhuAt4S451SJuHYGEzm/scene.splineswift")!
 let url = URL(string: "https://build.spline.design/8DX7ysrAJ3oDSok9hNgs/scene.splineswift")!
 let url = Bundle.main.url(forResource: "scene", withExtension: "splineswift")!
 try? SplineView(sceneFileURL: url).ignoresSafeArea(.all)
 */

#Preview {
    SUIComponents()
}
