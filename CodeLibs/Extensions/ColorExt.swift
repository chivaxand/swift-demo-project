import UIKit


extension UIColor {
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { traitCollection in
                switch traitCollection.userInterfaceStyle {
                case .dark:
                    return dark
                case .light, .unspecified:
                    return light
                @unknown default:
                    fatalError()
                }
            }
        } else {
            return light
        }
    }
    
    func interpolate(to endColor: UIColor, progress: Double) -> UIColor {
        guard progress >= 0 && progress <= 1 else {
            return self
        }
        
        let startComponents = self.components
        let endComponents = endColor.components
        
        return UIColor(
            red: startComponents.red + (endComponents.red - startComponents.red) * progress,
            green: startComponents.green + (endComponents.green - startComponents.green) * progress,
            blue: startComponents.blue + (endComponents.blue - startComponents.blue) * progress, 
            alpha: startComponents.alpha + (endComponents.alpha - startComponents.alpha) * progress
        )
    }
    
    var components: (red: Double, green: Double, blue: Double, alpha: Double) {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (Double(red), Double(green), Double(blue), Double(alpha))
    }

}

