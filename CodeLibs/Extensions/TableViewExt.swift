import UIKit

extension UITableView {
    func getCell<T: UITableViewCell>(withClass cellClass: T.Type) -> T? {
        let identifier = String(describing: cellClass)
        return self.getCell(withId: identifier, cellClass: cellClass) as? T
    }
    
    func getCell(withId identifier: String, cellClass: AnyClass?) -> UITableViewCell? {
        if let cell = self.dequeueReusableCell(withIdentifier: identifier) {
            return cell
        }
        if let cellClass = cellClass {
            self.register(cellClass, forCellReuseIdentifier: identifier)
            return self.dequeueReusableCell(withIdentifier: identifier)
        }
        return nil
    }
    
}
