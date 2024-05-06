import UIKit

class CircleImage2: UIView {
    
    var image: UIImage? { didSet { imageLayer.contents = image?.cgImage } }
    var borderWidth: CGFloat = 2.0 {
        didSet {
            borderLayer.lineWidth = borderWidth
            setNeedsLayout()
        }
    }
    var borderColor: UIColor = .white { didSet { borderLayer.strokeColor = borderColor.cgColor } }
    
    static func with(imageNamed: String,
                     width: CGFloat,
                     height: CGFloat,
                     borderWidth: CGFloat = 0.0,
                     borderColor: UIColor = UIColor.clear) -> CircleImage2 {
        let result = CircleImage2()
        result.borderWidth = borderWidth
        result.borderColor = borderColor
        result.image = UIImage(named: imageNamed)
        result.translatesAutoresizingMaskIntoConstraints = false
        result.widthAnchor.constraint(equalToConstant: width).isActive = true
        result.heightAnchor.constraint(equalToConstant: height).isActive = true
        return result
    }
    
    private let imageLayer: CALayer = {
        let layer = CALayer()
        layer.masksToBounds = true
        return layer
    }()
    
    private let borderLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 2.0
        return layer
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // MARK: - Setup
    
    private func setupView() {
        layer.addSublayer(borderLayer)
        layer.addSublayer(imageLayer)
        
        // Add shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 6.0
        layer.shadowOffset = CGSize(width: 3, height: 2)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        borderLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: borderWidth/2, dy: borderWidth/2)).cgPath
        borderLayer.frame = bounds
        
        imageLayer.frame = bounds.insetBy(dx: borderWidth, dy: borderWidth)
        imageLayer.contentsGravity = .resizeAspectFill
        imageLayer.cornerRadius = bounds.width/2 - borderWidth
        imageLayer.masksToBounds = true
        
        /*
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds.insetBy(dx: -borderWidth, dy: -borderWidth)
        maskLayer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: borderWidth, dy: borderWidth)).cgPath
        maskLayer.fillColor = UIColor.white.cgColor
        imageLayer.mask = maskLayer
        */
    }
}
