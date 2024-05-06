import SwiftUI

struct DrawingController: View {
    @State private var circleImage: UIImage? = nil
    
    var body: some View {
        VStack {
            if let image = circleImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
            } else {
                Text("No image")
            }
        }
        .onAppear(perform: createCircleImage)
    }
    
    func createCircleImage() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 200, height: 200))
        let image = renderer.image { context in
            let lightBlue = UIColor(red: 173/255, green: 216/255, blue: 230/255, alpha: 1.0)
            let circleSize: CGFloat = 200
            let borderWidth: CGFloat = 4
            
            // circle
            let circlePath = UIBezierPath(
                ovalIn: CGRect(
                    x: borderWidth / 2,
                    y: borderWidth / 2,
                    width: circleSize - borderWidth,
                    height: circleSize - borderWidth
                )
            )
            lightBlue.setFill()
            circlePath.fill()
            
            // border
            UIColor.blue.setStroke()
            circlePath.lineWidth = borderWidth
            circlePath.stroke()
        }
        
        self.circleImage = image
    }
}

#Preview {
    DrawingController()
}
