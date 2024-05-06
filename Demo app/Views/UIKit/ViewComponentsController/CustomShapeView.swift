import UIKit

class CustomShapeView: UIView {
    private let shapeLayer = CAShapeLayer()
    //private let shapeLayer = CustomShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        shapeLayer.fillColor = UIColor.red.cgColor
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 2.0
        layer.addSublayer(shapeLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.frame = bounds
        
        let customPath = UIBezierPath()
        customPath.move(to: CGPoint(x: bounds.midX, y: bounds.minY))
        customPath.addQuadCurve(to: CGPoint(x: bounds.maxX, y: bounds.midY), controlPoint: CGPoint(x: bounds.minX, y: bounds.maxY))
        customPath.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        customPath.close()
        
        shapeLayer.path = customPath.cgPath
    }
}


class CustomShapeLayer: CAShapeLayer {
    override init() {
        super.init()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        fillColor = UIColor.red.cgColor
        strokeColor = UIColor.blue.cgColor
        lineWidth = 2.0
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        
        let customPath = UIBezierPath()
        customPath.move(to: CGPoint(x: bounds.midX, y: bounds.minY))
        customPath.addQuadCurve(to: CGPoint(x: bounds.maxX, y: bounds.midY), controlPoint: CGPoint(x: bounds.minX, y: bounds.maxY))
        customPath.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        customPath.close()
        
        path = customPath.cgPath
    }
}
