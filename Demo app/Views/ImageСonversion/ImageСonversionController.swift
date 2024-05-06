import UIKit

// Icons:
// https://developer.apple.com/sf-symbols/
// https://fonts.google.com/icons

class ImageСonversionController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        
        let iconBlack = UIImage(named: "pc_black")!
        let iconWhite = UIImage(named: "pc_white")!
        
        XListView(views: [
            // original
            UI.stackView(axis: .horizontal, views: [
                UIImageView(image: iconBlack.withRenderingMode(.alwaysOriginal)).also({ v in v.tintColor = .red }),
                UIImageView(image: iconWhite.withRenderingMode(.alwaysOriginal)).also({ v in v.tintColor = .green }),
            ]),
            // template
            UI.stackView(axis: .horizontal, views: [
                UIImageView(image: iconBlack.withRenderingMode(.alwaysTemplate)).also({ v in v.tintColor = .red }),
                UIImageView(image: iconWhite.withRenderingMode(.alwaysTemplate)).also({ v in v.tintColor = .green }),
            ]),
            // original tinted
            UI.stackView(axis: .horizontal, views: [
                UIImageView(image: iconBlack.withTintColor(.blue, renderingMode: .alwaysOriginal)).also({ v in v.tintColor = .red }),
                UIImageView(image: iconWhite.withTintColor(.blue, renderingMode: .alwaysOriginal)).also({ v in v.tintColor = .green }),
            ]),
            // priginal tinted (custom)
            UI.stackView(axis: .horizontal, views: [
                UIImageView(image: iconBlack.image(withTintColor: .magenta)).also({ v in v.tintColor = .red }),
                UIImageView(image: iconWhite.image(withTintColor: .magenta)).also({ v in v.tintColor = .green }),
            ]),
        ]).add(toParentView: self.view)
    }
    
}

