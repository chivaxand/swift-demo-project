import UIKit

class CustomStackView: UIView {
    
    var arrangeType: ArrangeType = .vertical { didSet { updateArrangedViews() } }
    var draggingEnabled: Bool = false
    var arrangedSubviews: [UIView] { wrapperViews.map { $0.subview } }
    var contentSize: CGSize = .zero
    
    private var wrapperViews: [SubviewWrapper] = []
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init(arrange: ArrangeType, views: [UIView] = []) {
        self.arrangeType = arrange
        super.init(frame: .zero)
        setup()
        addArrangedSubviews(views)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let panGesture = FastPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        self.addGestureRecognizer(panGesture)
    }
    
    // MARK: Public Methods
    
    func addArrangedSubview(_ view: UIView) {
        addArrangedSubview(view, update: true)
    }
    
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { addArrangedSubview($0, update: false) }
        updateArrangedViews()
    }
    
    func removeArrangedSubview(_ view: UIView) {
        removeArrangedSubview(view, update: true)
    }
    
    func removeArrangedSubviews(_ views: [UIView]) {
        views.forEach { removeArrangedSubview($0, update: false) }
        updateArrangedViews()
    }
    
    func removeAllSubviews() {
        removeArrangedSubviews(self.arrangedSubviews)
    }
    
    private func addArrangedSubview(_ view: UIView, update: Bool) {
        let wrapper = SubviewWrapper(subview: view)
        wrapper.delegate = self
        wrapperViews.append(wrapper)
        addSubview(wrapper)
        wrapper.setNeedsLayout()
        wrapper.layoutIfNeeded()
        if (update) {
            updateArrangedViews()
        }
    }
    
    private func removeArrangedSubview(_ view: UIView, update: Bool) {
        if let index = wrapperViews.firstIndex(where: { $0.subview == view }) {
            let wrapper = wrapperViews.remove(at: index)
            wrapper.removeFromSuperview()
            wrapper.subview.removeFromSuperview()
            updateArrangedViews()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.wrapperViews.forEach { $0.setNeedsLayout() }
    }
    
    private var placeholderFrames: [CGRect] = []
    func updateArrangedViews() {
        let maxWidth: CGFloat = wrapperViews.reduce(0.0) { result, wrapper in
            return max(result, wrapper.frame.size.width)
        }
        let maxHeight: CGFloat = wrapperViews.reduce(0.0) { result, wrapper in
            return max(result, wrapper.frame.size.height)
        }
        var placeholderFrames: [CGRect] = []
        var previous: CGRect = .zero
        
        for wrapper in wrapperViews {
            let viewSize = wrapper.frame.size
            let placeholder: CGRect
            switch arrangeType {
            case .vertical:
                placeholder = CGRect(x: 0, y: previous.maxY, width: maxWidth, height: viewSize.height)
            case .horizontal:
                placeholder = CGRect(x: previous.maxX, y: 0, width: viewSize.width, height: maxHeight)
            }
            
            previous = placeholder
            placeholderFrames.append(placeholder)
            
            // update view frames
            let newFrame = CGRect(origin: placeholder.origin, size: viewSize)
            if wrapper != self.draggingView {
                wrapper.frame = newFrame
            }
        }
        
        self.placeholderFrames = placeholderFrames
        
        let lastFrame = placeholderFrames.last ?? .zero
        self.contentSize = CGSize(width: lastFrame.maxX, height: lastFrame.maxY)
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        return self.contentSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateArrangedViews()
    }
    
    // MARK: - Dragging Methods
    
    private func getSubviewIndex(at location: CGPoint) -> Int? {
        switch arrangeType {
        case .vertical:
            return self.placeholderFrames.firstIndex { location.y >= $0.minY && location.y <= $0.maxY }
        case .horizontal:
            return self.placeholderFrames.firstIndex { location.x >= $0.minX && location.x <= $0.maxX }
        }
    }
    
    private func getSubview(at location: CGPoint) -> SubviewWrapper? {
        guard let index = getSubviewIndex(at: location) else { return nil }
        return self.wrapperViews[index]
    }
    
    private var draggingView: SubviewWrapper? = nil
    private var dragOffset: CGPoint = .zero
    
    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        guard draggingEnabled else { return }
        
        let location = gesture.location(in: self)
        
        switch gesture.state {
        case .began:
            guard let draggingView = getSubview(at: location) else { return }
            self.draggingView = draggingView
            self.dragOffset = gesture.location(in: draggingView)
            draggingView.layer.zPosition = 9999 // move view to top
            //bringSubviewToFront(draggingView) // causes view jumping bug
            
            UIView.animate(withDuration: 0.2) {
                draggingView.layer.shadowColor = UIColor.black.cgColor
                draggingView.layer.shadowOpacity = 0.6
                draggingView.layer.shadowOffset = .zero
                draggingView.layer.shadowRadius = 8
            }
            
        case .changed:
            guard let draggingView = self.draggingView else { return }
            draggingView.frame.origin = CGPoint(x: location.x - self.dragOffset.x,
                                                y: location.y - self.dragOffset.y)
            if let draggingIndex = wrapperViews.firstIndex(where: { $0 == draggingView }),
               let targetIndex = getSubviewIndex(at: location),
               canMoveItems(fromIndex: draggingIndex, toIndex: targetIndex, draggingFrame: draggingView.frame)
            {
                let wrapper = wrapperViews.remove(at: draggingIndex)
                wrapperViews.insert(wrapper, at: targetIndex)
                
                UIView.animate(withDuration: 0.2) {
                    self.updateArrangedViews()
                }
            }
            
        default:
            let draggingView = self.draggingView
            self.draggingView = nil
            UIView.animate(withDuration: 0.2) {
                draggingView?.layer.shadowRadius = 0
                draggingView?.layer.shadowOpacity = 0
                self.updateArrangedViews()
            } completion: { finished in
                draggingView?.layer.zPosition = 0
            }
        }
    }
    
    private func canMoveItems(fromIndex: Int, toIndex: Int, draggingFrame: CGRect) -> Bool {
        if fromIndex == toIndex {
            return false
        }
        let frame = self.placeholderFrames[toIndex]
        let center = CGPoint(x: frame.origin.x + frame.size.width / 2, y: frame.origin.y + frame.size.height / 2)
        switch arrangeType {
        case .vertical:
            if fromIndex < toIndex {
                return draggingFrame.maxY > center.y
            } else if fromIndex > toIndex {
                return draggingFrame.minY < center.y
            }
        case .horizontal:
            if fromIndex < toIndex {
                return draggingFrame.maxX > center.x
            } else if fromIndex > toIndex {
                return draggingFrame.minX < center.x
            }
        }
        return false
    }
    
    // MARK: - Other
    
    enum ArrangeType {
        case vertical
        case horizontal
    }
    
    class SubviewWrapper: UIView {
        weak var delegate: CustomStackView?
        var subview: UIView
        init(subview: UIView) {
            self.subview = subview
            super.init(frame: subview.frame)
            self.translatesAutoresizingMaskIntoConstraints = false
            addSubview(subview)
            subview.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                subview.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                subview.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                subview.topAnchor.constraint(equalTo: self.topAnchor),
                subview.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}
