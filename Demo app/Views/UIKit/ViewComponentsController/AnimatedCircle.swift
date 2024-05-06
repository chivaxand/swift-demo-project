import UIKit

class AnimatedCircleLayer: CALayer {
    
    @NSManaged var circleBorderWidth: CGFloat
    var usePropertyAnimation: Bool = false
    
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "circleBorderWidth" {
            return true
        }
        return super.needsDisplay(forKey: key)
    }

    override init() {
        super.init()
        print("init()")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? AnimatedCircleLayer {
            print("init(layer:), circleBorderWidth: \(layer.circleBorderWidth)")
            self.circleBorderWidth = layer.circleBorderWidth
            self.usePropertyAnimation = layer.usePropertyAnimation
        }
    }
    
    override func draw(in ctx: CGContext) {
        let presentation = presentation() ?? self
        let borderWidth = presentation.circleBorderWidth
        print("draw(), borderWidth: \(borderWidth)")
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: bounds.midX, y: bounds.midY),
                                      radius: min(bounds.width, bounds.height) / 2 - borderWidth / 2,
                                      startAngle: 0,
                                      endAngle: .pi * 2,
                                      clockwise: true)
        
        ctx.setFillColor(UIColor.orange.cgColor)
        ctx.addPath(circlePath.cgPath)
        ctx.fillPath()
        
        ctx.setStrokeColor(UIColor.blue.cgColor)
        ctx.addPath(circlePath.cgPath)
        ctx.setLineWidth(borderWidth)
        ctx.strokePath()
    }

    override func action(forKey event: String) -> CAAction? {
        if self.usePropertyAnimation && event == #keyPath(AnimatedCircleLayer.circleBorderWidth) {
            let presentation = self.presentation() ?? self
            let animation = CABasicAnimation(keyPath: event)
            animation.fromValue = presentation.value(forKey: event)
            animation.duration = CATransaction.animationDuration()
            print("action(forKey:), \(String(describing: animation.fromValue))")
            return animation
        }
        return super.action(forKey: event)
    }
    
}


class AnimatedCircleView: UIView {
    
    override class var layerClass: AnyClass { return AnimatedCircleLayer.self }
    private var customLayer: AnimatedCircleLayer { return self.layer as! AnimatedCircleLayer }
    
    @objc dynamic var borderWidth: CGFloat {
        get { return customLayer.circleBorderWidth }
        set { customLayer.circleBorderWidth = newValue }
    }
    
//    override public func action(for layer: CALayer, forKey event: String) -> CAAction? {
//        if event == #keyPath(AnimatedCircleLayer.circleBorderWidth) {
//            let presentation = self.customLayer
//            let animation = CABasicAnimation(keyPath: event)
//            animation.fromValue = presentation.value(forKey: event)
//            animation.duration = CATransaction.animationDuration()
//            print("action(for:forKey:), \(String(describing: animation.fromValue))")
//            return animation
//        }
//        return super.action(for: layer, forKey: event)
//    }
    
    func animateWithBasicAnimation() {
        let animation = CABasicAnimation(keyPath: #keyPath(AnimatedCircleLayer.circleBorderWidth))
        animation.fromValue = 20.0
        animation.toValue = 4.0
        animation.duration = 0.5
        animation.fillMode = .forwards
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.borderWidth = animation.toValue as? CGFloat ?? 0
        }
        self.customLayer.add(animation, forKey: "progressAnimation")
        CATransaction.commit()
    }
    
    func animateWithViewAnimation() {
        self.customLayer.usePropertyAnimation = false
        self.borderWidth = 20;
        UIView.animate(withDuration: 3.0) {
            self.borderWidth = 4;
        }
    }
    
    func animateWithActionProperty() {
        self.customLayer.usePropertyAnimation = true
        self.borderWidth += 4
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        customLayer.frame = bounds
    }
    
    override func setNeedsDisplay() {
        self.layer.setNeedsDisplay()
    }
}
