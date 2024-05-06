import UIKit

class MaskedImageView2: UIView {
    
    // MARK: - Properties
    
    var image: UIImage? { didSet { setNeedsDisplay() } }
    var maskImage: UIImage? { didSet { setNeedsDisplay() } }
    
    // MARK: - Initialization
    
    static func with(image: UIImage?,
                     mask: UIImage?,
                     width: CGFloat,
                     height: CGFloat) -> MaskedImageView2 {
        let result = MaskedImageView2(frame: CGRect(x: 0, y: 0, width: width, height: height))
        result.translatesAutoresizingMaskIntoConstraints = false
        result.widthAnchor.constraint(equalToConstant: width).isActive = true
        result.heightAnchor.constraint(equalToConstant: height).isActive = true
        result.bounds = CGRect(x: 0, y: 0, width: width, height: height)
        result.image = image
        result.maskImage = mask
        return result
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = .clear
    }
    
    // MARK: - Drawing
    
    override func draw(_ rect: CGRect) {
        guard let image = image?.cgImage,
              let context = UIGraphicsGetCurrentContext() else {
            return
        }
        guard let maskImage = maskImage?.cgImage else {
            context.draw(image, in: rect)
            return
        }

        // Invert y-axis to match UIKit coordinate system
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.height)
        
        context.saveGState()
        context.clip(to: rect, mask: maskImage)
        context.draw(image, in: rect)
        context.restoreGState()
    }
}
