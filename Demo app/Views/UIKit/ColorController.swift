import UIKit

class ColorController: UIViewController {
    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.text = "X"
        label.textAlignment = .center
        label.backgroundColor = UIColor(white: 0.0, alpha: 0.05)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemMint
        self.navigationItem.title = "Color demo"
        self.navigationItem.largeTitleDisplayMode = .always
        
        if let navBar = self.navigationController?.navigationBar {
            navBar.prefersLargeTitles = true
        }
        
        let widthCnt = view.widthAnchor.constraint(equalToConstant: 200)
        widthCnt.priority = UILayoutPriority(999.0)
        widthCnt.isActive = true
        let heightCnt = view.heightAnchor.constraint(equalToConstant: 300)
        heightCnt.priority = UILayoutPriority(999.0)
        heightCnt.isActive = true
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        label.addGestureRecognizer(tapGesture)
        label.isUserInteractionEnabled = true
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
        ])
    }
    
    @objc func labelTapped() {
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
