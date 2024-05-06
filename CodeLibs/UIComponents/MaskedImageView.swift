import UIKit

class MaskedImageView: UIView {
    
    // MARK: - Properties
    
    var image: UIImage? { didSet { applyMask() } }
    var maskImage: UIImage? { didSet { applyMask() } }
    
    override var backgroundColor: UIColor? {
        get { super.backgroundColor }
        set {
            super.backgroundColor = newValue
            self.imageView.backgroundColor = newValue
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Initialization
    
    static func with(image: UIImage?,
                     mask: UIImage?,
                     width: CGFloat,
                     height: CGFloat) -> MaskedImageView {
        let result = MaskedImageView()
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
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // MARK: - Masking
    
    private func applyMask() {
        guard let image = image, let maskImage = maskImage else {
            imageView.image = self.image
            return
        }
        
        guard let maskRef = maskImage.cgImage,
              let originalImage = image.cgImage else
        {
            imageView.image = nil
            return
        }
        
        let width = originalImage.width
        let height = originalImage.height
        guard let context = CGContext(data: nil,
                                      width: width,
                                      height: height,
                                      bitsPerComponent: originalImage.bitsPerComponent,
                                      bytesPerRow: originalImage.bytesPerRow,
                                      space: originalImage.colorSpace!,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Little.rawValue) else {
            imageView.image = nil
            return
        }
        
        context.clip(to: CGRect(x: 0, y: 0, width: width, height: height), mask: maskRef)
        context.draw(originalImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        if let maskedImageRef = context.makeImage() {
            imageView.image = UIImage(cgImage: maskedImageRef, scale: image.scale, orientation: image.imageOrientation)
        } else {
            imageView.image = nil
        }
    }
}
