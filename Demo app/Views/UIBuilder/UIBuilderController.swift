import UIKit

class UIBuilderController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        createViews()
    }
    
    func createViews() {
        XListView(views: [

            UI.button("currentValueSubject", onTap: { [weak self] in
                guard let self else { return }
                print(">>> \(self)")
            }),
            
            UI.stackView(axis: .horizontal, spacing: 8, views: [
                UI.button("asyncIterator", onTap: { [weak self] in
                    guard let self else { return }
                    print(">>> \(self)")
                }),
                UI.button("stop", onTap: { [weak self] in
                    guard let self else { return }
                    print(">>> \(self)")
                }),
            ]),
        
        ]).add(toParentView: self.view)
    }
}
