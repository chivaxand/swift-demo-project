import UIKit
import CoreData

class UserInfo: ObservableObject {
    @Published var userId: Int
    @Published var name: String
    
    init(userId: Int, name: String) {
        self.userId = userId
        self.name = name
    }
    
    func setRandomName() {
        objectWillChange.send()
        self.name = .random(count: 15)
    }
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let logger = Logger(name:AppDelegate.self)
    internal var window: UIWindow?
    var userInfo = UserInfo(userId: 123, name: "Alex") // used for "@EnvironmentObject" demo

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let window = CustomWindow(frame: UIScreen.main.bounds)
//        self.window = window
//        window.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()!
//        window.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        logger.info("configurationForConnecting")
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        logger.info("didDiscardSceneSessions")
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Demo_app")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                let msg = "Database error: \(error), \(error.userInfo)"
                self.logger.error(msg)
                fatalError(msg)
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                let msg = "Database saving error: \(error), \(error.userInfo)"
                self.logger.error(msg)
                fatalError(msg)
            }
        }
    }

}

