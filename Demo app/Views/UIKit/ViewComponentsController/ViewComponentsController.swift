import UIKit

class ViewComponentsController: UIViewController {

    var animatedCircleView: AnimatedCircleView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.init(white: 0.9, alpha: 1.0)

        XListView(views: [
            UI.stackView(axis: .horizontal, spacing: 8, views: [
                CircleImage.with(imageNamed: "avatar1", width: 64, height: 64, borderWidth: 2, borderColor: UIColor.orange),
                CircleImage2.with(imageNamed: "avatar1", width: 64, height: 64, borderWidth: 2, borderColor: UIColor.orange),
            ]),
            
            UI.stackView(axis: .horizontal, spacing: 8, views: [
                MaskedImageView.with(image: UIImage(named: "avatar1"), mask: UIImage(systemName:"star.fill")!, width: 64, height: 64),
                MaskedImageView2.with(image: UIImage(named: "avatar1"), mask: UIImage(systemName:"star.fill")!, width: 64, height: 64)
            ]),
            
            UI.stackView(axis: .horizontal, spacing: 8, views: [
                AnimatedCircleView().also({ v in
                    v.backgroundColor = .clear
                    v.widthAnchor.constraint(equalToConstant: 128).isActive = true
                    v.heightAnchor.constraint(equalToConstant: 128).isActive = true
                    self.animatedCircleView = v
                }),
                UI.stackView(axis: .vertical, spacing: 8, views: [
                    UI.button("CAAnimation", onTap: { [weak self] in
                        print("CAAnimation")
                        self?.animatedCircleView.animateWithBasicAnimation()
                    }),
                    UI.button("UIView animation", onTap: { [weak self] in
                        print("UIView animation")
                        self?.animatedCircleView.animateWithViewAnimation()
                    }),
                    UI.button("Action property", onTap: { [weak self] in
                        print("Action property")
                        self?.animatedCircleView.animateWithActionProperty()
                    }),
                ]),
            ]),
            
            CustomShapeView().also({ v in
                v.translatesAutoresizingMaskIntoConstraints = false
                v.widthAnchor.constraint(equalToConstant: 40).isActive = true
                v.heightAnchor.constraint(equalToConstant: 40).isActive = true
            }),
            
        ]).add(toParentView: self.view)
    }
    
}
