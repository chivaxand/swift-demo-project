import UIKit
import SwiftUI

class RootController: UIViewController {

    struct ListItem {
        let title: String
        let controller: (() -> UIViewController?)?
    }
    
    private let logger = Logger(name: RootController.self)
    
    @IBOutlet var tableView: UITableView!
    
    private lazy var itemsList = {[
        ListItem(title: "Playground", controller: { return PlaygroundController() }),
        ListItem(title: "SwiftUI", controller: {
            let nav = self.navigationController!
            return UIHostingController(rootView: SwiftUIRootView()
                .environment(\.navigationController, nav))
        }),
        ListItem(title: "UIKit", controller: { return RootUIKitController() }),
        ListItem(title: "UIBuilder", controller: { return UIBuilderController() }),
        ListItem(title: "Dependency injection", controller: { return UIHostingController(rootView: DependencyView()) }),
        ListItem(title: "JSON parsing", controller: { return UIHostingController(rootView: JsonParsingView()) }),
        ListItem(title: "Encode / Decode", controller: { return EncoderDecoderController() }),
        ListItem(title: "Thread / Queue", controller: { return ThreadQueueController() }),
        ListItem(title: "Publishers", controller: { return PublishersDemoController() }),
        ListItem(title: "Custom observers / Publishers", controller: { return CustomObserversController() }),
        ListItem(title: "Property wrapper / Observer", controller: { return PropertyWrapperController() }),
        ListItem(title: "Errors", controller: { return UIHostingController(rootView: ErrorsDemo()) }),
        ListItem(title: "Light / Dark theme", controller: { return LightDarkThemeControllerViewController() }),
        ListItem(title: "Image conversion", controller: { return ImageСonversionController() }),
        ListItem(title: "Drawing", controller: { return UIHostingController(rootView: DrawingController()) }),
        ListItem(title: "Collection conversion", controller: { return CollectionConversionController() }),
        ListItem(title: "Result builder", controller: { return UIHostingController(rootView: ResultBuilderController()) }),
        ListItem(title: "Regexp", controller: { return UIHostingController(rootView: RegexpController()) }),
        ListItem(title: "Class, Struct", controller: { return UIHostingController(rootView: ClassStructView()) }),
        ListItem(title: "Actor demo", controller: { return UIHostingController(rootView: ActorDemo()) }),
        ListItem(title: "Requests / Download", controller: { return UIHostingController(rootView: RequestsDownloadDemo()) }),
        ListItem(title: "WebSocket", controller: { return WebSocketClientController() }),
        ListItem(title: "Data formatting", controller: { return UIHostingController(rootView:DataFormattingDemo()) }),
        ListItem(title: "Keychain storage", controller: { return KeychainController() }),
        ListItem(title: "Macros", controller: { return MacrosController() }),
    ]}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Demo list"
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
}

extension RootController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.getCell(withClass: RootTableCell.self) else { fatalError("no table cell") }
        let item = self.itemsList[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = item.title
        return cell
    }
}

extension RootController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logger.info("Selected item: \(indexPath)")
        let item = self.itemsList[indexPath.row]
        if let controller = item.controller?() {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


class RootTableCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
