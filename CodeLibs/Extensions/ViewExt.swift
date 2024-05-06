import UIKit


extension UIView {
    
    func addConstraints(toParent parent: UIView?, leading: CGFloat? = nil, trailing: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil) {
        guard let parent else { return }
        if let leading {
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: leading).isActive = true
        }
        if let trailing {
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: -trailing).isActive = true
        }
        if let top {
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: top).isActive = true
        }
        if let bottom {
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -bottom).isActive = true
        }
    }
}

