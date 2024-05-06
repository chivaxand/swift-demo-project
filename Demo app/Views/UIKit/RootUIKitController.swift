import UIKit

class RootUIKitController: UIViewController {
    
    struct ListItem {
        let title: String
        let controller: (() -> UIViewController?)?
    }
    
    private let logger = Logger(name: RootUIKitController.self)
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    private lazy var itemsList = [
        ListItem(title: "Navigation", controller: { return NavDemoController() }),
        ListItem(title: "View components", controller: { return ViewComponentsController() }), 
        ListItem(title: "Table drag items", controller: { return TableViewDragItemsController() }), 
        ListItem(title: "Custom stack view", controller: { return CustomStackViewController() }), 
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        // Set up navigation bar
        self.navigationItem.title = "Demo list"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(onStarButtonPress))
    }
    
    @objc func onStarButtonPress() {
        logger.info("Star button pressed")
    }
}

extension RootUIKitController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.itemsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = self.itemsList[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = item.title
        return cell
    }
}

extension RootUIKitController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        logger.info("Selected item: \(indexPath)")
        let item = self.itemsList[indexPath.row]
        if let controller = item.controller?() {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
