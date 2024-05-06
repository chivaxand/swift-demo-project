import UIKit

class NavDemoController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        XListView(views: [
            createButton(title: "Navigation controller", action: #selector(buttonNavTapped)),
            createButton(title: "Present Page Sheet", action: #selector(button1Tapped)),
            createButton(title: "Custom with autosize", action: #selector(button2Tapped)),
            createButton(title: "Custom with fixed size", action: #selector(button3Tapped)),
            createButton(title: "Custom with fixed size", action: #selector(button4Tapped)),
            createButton(title: "Go to App settings", action: #selector(goToAppSettings)),
            createButton(title: "Go to App Notifications", action: #selector(goToAppSettingsNotifications)),
            createButton(title: "Go to Settings > General", action: #selector(goToSettingsGeneral)),
        ]).add(toParentView: self.view)
    }
    
    func createButton(title: String, action: Selector) -> UIButton {
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        //configuration.image = UIImage(systemName: "swift")
        // configuration.imagePadding = 10
        configuration.titlePadding = 10
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let button = UIButton(configuration: configuration)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    @objc func buttonNavTapped() {
        guard let nav = self.navigationController else { return }
        nav.pushViewController(ColorController(), animated: true)
    }
    
    @objc func button1Tapped() {
        let controller = ColorController()
        /*
        case pageSheet = 1
        case formSheet = 2
        case currentContext = 3
        case custom = 4
        case overFullScreen = 5
        case overCurrentContext = 6
        case popover = 7
        */
        controller.modalPresentationStyle = .pageSheet
        controller.modalTransitionStyle = .coverVertical // .coverVertical, .flipHorizontal, .crossDissolve
        controller.sheetPresentationController?.prefersGrabberVisible = true // Show grabber
        controller.sheetPresentationController?.detents = [.medium(), .large()]
        present(controller, animated: true, completion: nil)
    }
    
    @objc func button2Tapped() {
        let controller = ColorController()
        let transitioningDelegate = CenteredPresentationController.transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalTransitionStyle = .crossDissolve
        controller.transitioningDelegate = transitioningDelegate
        present(controller, animated: true, completion: nil)
    }
    
    @objc func button3Tapped() {
        let controller = ColorController()
        let transitioningDelegate = FixedSizePresentationController.transitionDelegate
        controller.modalPresentationStyle = .custom
        controller.modalTransitionStyle = .crossDissolve
        controller.transitioningDelegate = transitioningDelegate
        present(controller, animated: true, completion: nil)
    }
    
    @objc func button4Tapped() {
        let controller = ColorController()
        controller.modalPresentationStyle = .popover
        controller.modalTransitionStyle = .crossDissolve
        controller.preferredContentSize = CGSize(width: 300, height: 300)
        if let popover = controller.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
            // if used witout delegate then works only on iPad
            popover.delegate = UIPopoverPresentationController.delegateWithNoAdaptiveStyle
        }
        self.present(controller, animated: true, completion: nil)
    }
    
    @objc func goToAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            print("Link: \(url)")
            UIApplication.shared.open(url)
        }
    }
    
    @objc func goToAppSettingsNotifications() {
        if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
            print("Link: \(url)")
            UIApplication.shared.open(url)
        }
    }
    
    @objc func goToSettingsGeneral() {
        if let url = URL(string: "prefs:root=General") {
            print("Link: \(url)")
            UIApplication.shared.open(url)
        }
    }

}


extension UIPopoverPresentationController {
    class UIPopoverDelegate : NSObject, UIPopoverPresentationControllerDelegate {
        func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none
        }
    }
    static var delegateWithNoAdaptiveStyle : UIPopoverPresentationControllerDelegate = {
        return UIPopoverDelegate()
    }()
}


class CenteredPresentationController: UIPresentationController {
    
    static var transitionDelegate: UIViewControllerTransitioningDelegate = {
        class CenteredPresentationControllerTransitionDelegate : NSObject, UIViewControllerTransitioningDelegate {
            func presentationController(forPresented presented: UIViewController,
                                        presenting: UIViewController?,
                                        source: UIViewController) -> UIPresentationController? {
                return CenteredPresentationController(presentedViewController: presented, presenting: presenting)
            }
        }
        return CenteredPresentationControllerTransitionDelegate()
    }()
    
    override func containerViewWillLayoutSubviews() {
        print("container will layout subviews")
        super.containerViewWillLayoutSubviews()
        guard let view = presentedView,
              let container = view.superview else { return }
        
        let padding = 16.0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // remove constraints to superview
        let superviewConstraints = view.constraints.filter { constraint in
            return constraint.firstItem === container || constraint.secondItem === container
        }
        NSLayoutConstraint.deactivate(superviewConstraints)
        
        // align in center and limit max size to borders
        view.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        view.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: padding).isActive = true
        view.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -padding).isActive = true
        view.topAnchor.constraint(greaterThanOrEqualTo: container.topAnchor, constant: padding).isActive = true
        view.bottomAnchor.constraint(lessThanOrEqualTo: container.bottomAnchor, constant: -padding).isActive = true
    }
    
    override func presentationTransitionWillBegin() {
        let color = UIColor(white: 0.0, alpha: 0.2)
        guard let coordinator = presentingViewController.transitionCoordinator else {
            containerView?.backgroundColor = color
            return
        }
        coordinator.animate(alongsideTransition: { context in
            self.containerView?.backgroundColor = color
        }, completion: nil)
    }
    
    override func dismissalTransitionWillBegin() {
        let color: UIColor = .clear
        guard let coordinator = presentingViewController.transitionCoordinator else {
            containerView?.backgroundColor = color
            return
        }
        coordinator.animate(alongsideTransition: { context in
            self.containerView?.backgroundColor = color
        }, completion: nil)
    }
}


class FixedSizePresentationController: UIPresentationController {
    
    static var transitionDelegate: UIViewControllerTransitioningDelegate = {
        class FixedSizePresentationControllerTransitionDelegate : NSObject, UIViewControllerTransitioningDelegate {
            func presentationController(forPresented presented: UIViewController,
                                        presenting: UIViewController?,
                                        source: UIViewController) -> UIPresentationController? {
                return FixedSizePresentationController(presentedViewController: presented, presenting: presenting)
            }
        }
        return FixedSizePresentationControllerTransitionDelegate()
    }()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else { return .zero }
        let containerBounds = containerView.bounds
        let paddingX = 16.0
        let width = min(400.0, containerBounds.width - paddingX*2)
        let height = 200.0
        let x = (containerBounds.width - width) / 2
        let y = (containerBounds.height - height) / 2
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        guard let view = presentedView else { return }
        view.translatesAutoresizingMaskIntoConstraints = true
        view.frame = self.frameOfPresentedViewInContainerView // update size on rotation
    }
}
