import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private let logger = Logger(name: SceneDelegate.self)
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // `window` property will automatically be initialized if storyboard used
        logger.info("Connect scene to session")
        
        // replace window with custom to handle theme changes
        let window = CustomWindow(windowScene: scene as! UIWindowScene)
        window.rootViewController = self.window?.rootViewController
        self.window = window
        window.makeKeyAndVisible()
        
        // change appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(white: 0.0, alpha: 0.2)
        appearance.titleTextAttributes = [.foregroundColor : UIColor.black]
        // appearance.largeTitleTextAttributes = appearance.titleTextAttributes
        
        if let nav = self.window?.rootViewController as? UINavigationController {
            let navBar = nav.navigationBar
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.compactAppearance = appearance
            navBar.barTintColor = UIColor.black
            navBar.tintColor = navBar.barTintColor
            let barItem = UIBarButtonItem.appearance()
            barItem.tintColor = navBar.barTintColor
        }
        
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        let window = UIWindow(windowScene: windowScene)
//        window.rootViewController = RootController()
//        self.window = window
//        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        logger.info("Did disconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        logger.info("Did become active")
    }

    func sceneWillResignActive(_ scene: UIScene) {
        logger.info("Will resign active") // will move from an active state to an inactive state
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        logger.info("Will enter foreground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        logger.info("Did enter background")
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }

}

