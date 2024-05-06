import Foundation

class SelectorNotifier<EventType: Equatable> {

    private struct Subscription: Hashable {
        weak var target: AnyObject?
        let selector: Selector
        let eventType: EventType
        
        func hash(into hasher: inout Hasher) {
            if let target = target {
                hasher.combine(ObjectIdentifier(target))
            }
            hasher.combine(selector)
        }
        
        static func == (lhs: Subscription, rhs: Subscription) -> Bool {
            return lhs.target === rhs.target && lhs.selector == rhs.selector
        }
    }
    
    private var subscriptions = Set<Subscription>()
    private var notificationQueue: DispatchQueue?

    init(queue: DispatchQueue? = DispatchQueue.main) {
        self.notificationQueue = queue
    }
    
    func addTarget(_ target: AnyObject, selector: Selector, _ eventType: EventType) {
        let subscription = Subscription(target: target, selector: selector, eventType: eventType)
        subscriptions.insert(subscription)
    }
    
    func removeTarget(_ target: AnyObject, selector: Selector) {
        subscriptions = subscriptions.filter { !($0.target === target && $0.selector == selector) }
    }
    
    func removeTarget(_ target: AnyObject) {
        subscriptions = subscriptions.filter { !($0.target === target) }
    }
    
    func notify(with eventType: EventType, _ param1: AnyObject? = nil) {
        if let queue = self.notificationQueue {
            queue.async {
                self._notify(with: eventType, param1)
            }
        } else {
            _notify(with: eventType, param1)
        }
    }
    
    private func _notify(with eventType: EventType, _ param1: AnyObject? = nil) {
        for subscription in subscriptions {
            if subscription.eventType == eventType {
                let target = subscription.target
                let selector = subscription.selector
                _ = target?.perform(selector, with: param1)
            }
        }
    }
}
