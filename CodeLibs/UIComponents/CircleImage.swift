import UIKit

class CircleImage: UIView {
    
    var image: UIImage? { didSet { setNeedsDisplay() } }
    var borderWidth: CGFloat = 2.0 { didSet { setNeedsDisplay() } }
    var borderColor: UIColor = .white { didSet { setNeedsDisplay() } }
    
    static func with(imageNamed: String,
                     width: CGFloat,
                     height: CGFloat,
                     borderWidth: CGFloat = 0.0,
                     borderColor: UIColor = UIColor.clear) -> CircleImage {
        let result = CircleImage()
        result.borderWidth = borderWidth
        result.borderColor = borderColor
        result.image = UIImage(named: imageNamed)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.widthAnchor.constraint(equalToConstant: width).isActive = true
        result.heightAnchor.constraint(equalToConstant: height).isActive = true
        return result
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Other
    
    private func setupView() {
        self.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        guard let image = image?.cgImage else { return }
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        // Invert y-axis to match UIKit coordinate system
        ctx.scaleBy(x: 1.0, y: -1.0)
        ctx.translateBy(x: 0.0, y: -rect.height)
        
        // Draw border
        ctx.setStrokeColor(borderColor.cgColor)
        ctx.setLineWidth(borderWidth)
        let borderRect = CGRect(x: borderWidth / 2,
                                y: borderWidth / 2,
                                width: rect.width - borderWidth,
                                height: rect.height - borderWidth)
        ctx.strokeEllipse(in: borderRect)
        
        let imageRect = getImageRectToFill(size: CGSize(width: image.width, height: image.height), insideSize: rect.size)
        //let imageRect = getImageRectToFit(size: CGSize(width: image.width, height: image.height), insideSize: rect.size)
        
        ctx.saveGState()
        ctx.addEllipse(in: CGRect(x: borderWidth, 
                                  y: borderWidth,
                                  width: rect.width - 2 * borderWidth,
                                  height: rect.height - 2 * borderWidth))
        ctx.clip()
        ctx.draw(image, in: imageRect)
        ctx.restoreGState()
    }
    
    private func getImageRectToFill(size: CGSize, insideSize destSize: CGSize) -> CGRect {
        let imageAspect = size.width / size.height
        let circleAspect = destSize.width / destSize.height
        var scaledImageRect = CGRect.zero
        
        if imageAspect > circleAspect {
            // Image is wider than rectangle
            let scaledHeight = destSize.height - 2 * borderWidth
            let scaledWidth = scaledHeight * imageAspect
            scaledImageRect.size = CGSize(width: scaledWidth, height: scaledHeight)
            scaledImageRect.origin.x = (destSize.width - scaledWidth) / 2
            scaledImageRect.origin.y = borderWidth
        } else {
            // Image is taller than rectangle
            let scaledWidth = destSize.width - 2 * borderWidth
            let scaledHeight = scaledWidth / imageAspect
            scaledImageRect.size = CGSize(width: scaledWidth, height: scaledHeight)
            scaledImageRect.origin.x = borderWidth
            scaledImageRect.origin.y = (destSize.height - scaledHeight) / 2
        }
        
        return scaledImageRect
    }
    
    private func getImageRectToFit(size: CGSize, insideSize destSize: CGSize) -> CGRect {
        let imageAspect = size.width / size.height
        let circleAspect = destSize.width / destSize.height
        var scaledImageRect = CGRect.zero
        
        if imageAspect > circleAspect {
            // Image is wider than rectangle
            let scaledWidth = destSize.width - 2 * borderWidth
            let scaledHeight = scaledWidth / imageAspect
            scaledImageRect.size = CGSize(width: scaledWidth, height: scaledHeight)
            scaledImageRect.origin.x = borderWidth
            scaledImageRect.origin.y = (destSize.height - scaledHeight) / 2
        } else {
            // Image is taller than or equal to the rectangle
            let scaledHeight = destSize.height - 2 * borderWidth
            let scaledWidth = scaledHeight * imageAspect
            scaledImageRect.size = CGSize(width: scaledWidth, height: scaledHeight)
            scaledImageRect.origin.x = (destSize.width - scaledWidth) / 2
            scaledImageRect.origin.y = borderWidth
        }
        
        return scaledImageRect
    }
}
