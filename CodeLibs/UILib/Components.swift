import UIKit


@objc protocol UndeprecatedContentEdgeInsets {
    @objc var contentEdgeInsets: UIEdgeInsets { get set }
}

class XButton: UIButton, UndeprecatedContentEdgeInsets {
    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    convenience init(title: String, onTap: (() -> Void)?) {
        self.init(frame: .zero)
        setTitle(title, for: .normal)
        self.onTap = onTap
    }

    private func setupButton() {
        (self as UndeprecatedContentEdgeInsets).contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        if #available(iOS 15.0, *) {
            configuration?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        }
        backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0)
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 10
        clipsToBounds = true
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        onTap?()
    }
}


class XListView: UIView {
    let scrollView = UIScrollView()
    let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        initialSetup()
    }
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    convenience init(views: [UIView]) {
        self.init()
        addViews(views)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialSetup()
    }
    
    func initialSetup() {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // scroll view
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        // stack view
        scrollView.addSubview(stackView)
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        stackView.spacing = 8
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }

    @discardableResult func addViews(_ views: [UIView]) -> XListView {
        for view in views {
            stackView.addArrangedSubview(view)
        }
        return self
    }
    
    @discardableResult func add(toParentView parent: UIView) -> XListView {
        parent.addSubview(self)
        self.leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        return self
    }
    
    @discardableResult func setAxis(_ axis: NSLayoutConstraint.Axis) -> XListView {
        self.stackView.axis = axis
        return self
    }
    
    @discardableResult func setAlignment(_ alignment: UIStackView.Alignment) -> XListView {
        self.stackView.alignment = alignment
        return self
    }
    
    @discardableResult func setSpacing(_ spacing: CGFloat) -> XListView {
        self.stackView.spacing = spacing
        return self
    }
    
    @discardableResult func setMargins(left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil) -> XListView {
        var margins = self.stackView.layoutMargins
        if let left { margins.left = left }
        if let right { margins.right = right }
        if let top { margins.top = top }
        if let bottom { margins.bottom = bottom }
        self.stackView.layoutMargins = margins
        return self
    }
    
}
