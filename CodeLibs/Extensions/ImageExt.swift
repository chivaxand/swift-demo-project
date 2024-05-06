import UIKit
import Combine

extension UIImage {
    static func dynamicImageWith(light: @autoclosure () -> UIImage,
                                 dark: @autoclosure () -> UIImage) -> UIImage {
        if #available(iOS 13.0, *) {
            let lightTC = UITraitCollection(traitsFrom: [.current, .init(userInterfaceStyle: .light)])
            var lightImage: UIImage!
            lightTC.performAsCurrent {
                lightImage = light().createCopy()
            }
            
            let darkTC = UITraitCollection(traitsFrom: [.current, .init(userInterfaceStyle: .dark)])
            var darkImage: UIImage!
            darkTC.performAsCurrent {
                darkImage = dark().createCopy()
            }
            
            lightImage.imageAsset?.register(darkImage, with: UITraitCollection(userInterfaceStyle: .dark))
            return lightImage
        } else {
            return light()
        }
    }

    func createCopy() -> UIImage {
        if let cgImage = self.cgImage {
            return UIImage(cgImage: cgImage, scale: self.scale, orientation: self.imageOrientation)
        }
        return self
    }
    
    static func generate(withColor color: UIColor, size: CGSize = CGSize(width: 24, height: 24)) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
 
    func image(withTintColor tintColor: UIColor) -> UIImage {
        guard let cgImage = cgImage else { return self }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        tintColor.setFill()
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)
        context.draw(cgImage, in: rect)
        context.setBlendMode(.sourceIn)
        context.addRect(rect)
        context.drawPath(using: .fill)
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return coloredImage.withRenderingMode(.alwaysOriginal)
    }
}


extension UIImage {
    
    static func loadImageAsFuture(url: URL?) -> Future<UIImage, Error> {
        return Future { promise in
            guard let url else {
                let error = NSError(domain: "URL error", code: 0, userInfo: [NSLocalizedDescriptionKey: "URL is not corect"])
                promise(.failure(error))
                return
            }
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    let error = NSError(domain: "Image Decoding", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image data"])
                    promise(.failure(error))
                    return
                }
                
                promise(.success(image))
            }.resume()
        }
    }
}
