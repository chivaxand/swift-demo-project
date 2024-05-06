import UIKit

class LightDarkThemeControllerViewController: UIViewController {

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var viewRect: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: traitCollectionDidChangeNotification, object: nil)
        
        // dynamic color
        let dynamicColor = UIColor { traitCollection in
            print("Dynamic color read")
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .init(white: 0.3, alpha: 1.0)
            case .light, .unspecified:
                return .white
            @unknown default:
                fatalError()
            }
        }
        print("Dynamic color: \(dynamicColor)")
        self.view.backgroundColor = dynamicColor
        print("Dynamic color after assign: \(self.view.backgroundColor!)")
        
        let viewRect = UIView(frame: .zero).also { v in
            v.widthAnchor.constraint(equalToConstant: 100).isActive = true
            v.heightAnchor.constraint(equalTo: v.widthAnchor, multiplier: 1.0).isActive = true
            v.backgroundColor = XColor.withBlock { [weak self] in
                guard let self else { return UIColor.black }
                let dark = self.traitCollection.userInterfaceStyle == .dark || UITraitCollection.current.userInterfaceStyle == .dark
                return dark ? UIColor.green : UIColor.blue
            }
            print("XColor after assign: \(v.backgroundColor!)") // will be created new color based on "CGColor"
        }
        self.viewRect = viewRect
        
        // dynamic image
        let dynamicImage = UIImage.dynamicImageWith(light: UIImage(systemName: "sun.max")!, dark: UIImage(systemName: "moon")!)
        // let dynamicImage = UIImage(named: "mode_icon")
        // let dynamicImage = UIImage.dynamicImageWith(light: UIImage.generate(withColor: .red), dark: UIImage.generate(withColor: .green) )
        let imageView = UIImageView(image: dynamicImage)
        imageView.contentMode = .scaleAspectFit
        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 1.0).isActive = true
        
        // list with views
        XListView(views: [
            UI.button("Device theme", onTap: { [weak self] in
                print("Device theme")
                self?.applyTheme(.unspecified)
            }),
            UI.button("Light theme", onTap: { [weak self] in
                print("Light theme")
                self?.applyTheme(.light)
            }),
            UI.button("Dark theme", onTap: { [weak self] in
                print("Dark theme")
                self?.applyTheme(.dark)
            }),
            imageView,
            viewRect,
        ]).add(toParentView: self.view)
    }
    
    @objc func themeChanged() {
        print("Received theme changed notification")
    }

    func applyTheme(_ theme: UIUserInterfaceStyle) {
        /*
        // deprecated
        for window in UIApplication.shared.windows {
            window.rootViewController?.overrideUserInterfaceStyle = theme
        } */
        for scene in UIApplication.shared.connectedScenes {
            if let scene = scene as? UIWindowScene {
                for window in scene.windows {
                    window.rootViewController?.overrideUserInterfaceStyle = theme
                }
            }
        }
    }
    
    // will not trigger if ".overrideUserInterfaceStyle" is not ".unspecified"
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        print("Trait collection changed")
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            // updateColors()
        }
    }

}


let traitCollectionDidChangeNotification = NSNotification.Name("traitCollectionDidChange")
final class CustomWindow: UIWindow {
    private var userInterfaceStyle = UITraitCollection.current.userInterfaceStyle
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        let currentStyle = UITraitCollection.current.userInterfaceStyle
        if currentStyle != userInterfaceStyle {
            print("Theme changed to \(currentStyle == .dark ? "Dark" : "Light")")
            self.userInterfaceStyle = currentStyle
            NotificationCenter.default.post(name: traitCollectionDidChangeNotification, object: self)
        }
    }
}

