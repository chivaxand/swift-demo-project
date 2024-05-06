import UIKit

@objcMembers class XColor: UIColor {
    private var colorBlock: (() -> UIColor)?
    
    static func withBlock(_ block: @escaping () -> UIColor) -> XColor {
        let color = XColor()
        color.colorBlock = block
        return color
    }
    
    deinit {
        print("XColor deinit")
    }
    
    var color: UIColor {
        print("XColor get")
        return colorBlock?() ?? UIColor.clear
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        return self.color.isEqual(object)
    }
    
//    override func isEqual(to color: UIColor!) -> Bool {
//        return self.color.isEqual(to: color)
//    }
    
    override var hash: Int {
        return 0 // should be used "isEqual"
    }
    
    override var cgColor: CGColor {
        return color.cgColor
    }
    
    override func set() {
        color.set()
    }
    
    override func setFill() {
        color.setFill()
    }
    
    override func setStroke() {
        color.setStroke()
    }
    
    override func getWhite(_ white: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        return color.getWhite(white, alpha: alpha)
    }
    
    override func getHue(_ hue: UnsafeMutablePointer<CGFloat>?, saturation: UnsafeMutablePointer<CGFloat>?, brightness: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        return color.getHue(hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    
    override func getRed(_ red: UnsafeMutablePointer<CGFloat>?, green: UnsafeMutablePointer<CGFloat>?, blue: UnsafeMutablePointer<CGFloat>?, alpha: UnsafeMutablePointer<CGFloat>?) -> Bool {
        return color.getRed(red, green: green, blue: blue, alpha: alpha)
    }
    
    override func withAlphaComponent(_ alpha: CGFloat) -> UIColor {
        return color.withAlphaComponent(alpha)
    }
    
    #if canImport(CoreImage)
    override var ciColor: CIColor {
        return color.ciColor
    }
    #endif
}

/*
// Cannot inherit from Core Foundation type 'CGColor'
@objcMembers class XCGColor: CGColor { }
*/
