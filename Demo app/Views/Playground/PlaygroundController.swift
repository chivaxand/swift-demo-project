import UIKit

class PlaygroundController: UIViewController {

    var label1: UILabel!
    var label2: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        
        TestObjc().run()
        
        XListView(views: [
            UI.label(text: "").also { self.label1 = $0 },
            UI.label(text: "").also { self.label2 = $0 },
            
            UI.stackView(axis: .horizontal, spacing: 10, views: [
                UI.button("AAA", onTap: { [weak self] in
                    guard let self else { return }
                    self.showText("AAA")
                }),
                UI.button("BBB", onTap: {  [weak self] in
                    guard let self else { return }
                    self.showText("BBB")
                }),
            ]),
        ]).add(toParentView: self.view)
    }
    
    func showText(_ text: String?) {
        self.label1.text = text ?? "nil"
    }
    
}
