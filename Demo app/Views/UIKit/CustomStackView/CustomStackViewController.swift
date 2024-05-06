import UIKit

class CustomStackViewController: UIViewController {

    var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let container = CustomStackView(arrange: .vertical, views: [
            UILabel().also { $0.text = "Hello"; $0.backgroundColor = .red },
            UIView().also {
                $0.backgroundColor = .blue
                let label = UILabel().also {
                    self.label = $0
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    $0.text = "World";
                    $0.backgroundColor = .yellow
                }
                $0.addSubview(label)
                label.leadingAnchor.constraint(equalTo: $0.leadingAnchor, constant: 30).isActive = true
                label.trailingAnchor.constraint(equalTo: $0.trailingAnchor, constant: -30).isActive = true
                label.topAnchor.constraint(equalTo: $0.topAnchor, constant: 10).isActive = true
                label.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -10).isActive = true
            },
            UIView().also {
                $0.backgroundColor = .green
                let label = UILabel().also {
                    $0.translatesAutoresizingMaskIntoConstraints = false
                    $0.text = "!!!";
                    $0.backgroundColor = .yellow
                }
                $0.addSubview(label)
                label.leadingAnchor.constraint(equalTo: $0.leadingAnchor, constant: 20).isActive = true
                label.trailingAnchor.constraint(equalTo: $0.trailingAnchor, constant: -20).isActive = true
                label.topAnchor.constraint(equalTo: $0.topAnchor, constant: 20).isActive = true
                label.bottomAnchor.constraint(equalTo: $0.bottomAnchor, constant: -20).isActive = true
            }
        ])
        container.backgroundColor = .gray
        container.draggingEnabled = true
        
        XListView(views: [
            container,
            
            UI.stackView(axis: .horizontal, spacing: 10, views: [
                UI.button("Change text", onTap: { [weak self] in
                    guard let self else { return }
                    self.label.text = String.random(count: Int.random(in: 2...20))
                }),
            ]),
            
        ]).add(toParentView: self.view)
        
    }

}
