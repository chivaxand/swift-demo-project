import UIKit


enum UI {
    static func stackView(axis: NSLayoutConstraint.Axis,
                          spacing: CGFloat = 0,
                          alignment:  UIStackView.Alignment = .center,
                          views: [UIView]) -> UIStackView {
        let view = UIStackView(arrangedSubviews: views)
        view.spacing = spacing
        view.alignment = alignment
        view.axis = axis
        return view
    }
    
    static func label(text: String,
                      font: UIFont? = nil,
                      textColor: UIColor? = nil,
                      textAlignment: NSTextAlignment = .left,
                      numberOfLines: Int = 1) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.numberOfLines = numberOfLines
        return label
    }
    
    static func button(_ text: String, onTap: (() -> Void)?) -> XButton {
        return XButton(title: text, onTap: onTap)
    }
}
