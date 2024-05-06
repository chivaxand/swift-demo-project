import UIKit
import Combine
import SwiftUI

class CustomObserversController: UIViewController {
    
    enum TapEvent: Equatable {
        case onTap, onLongPress
    }
    
    var subscriptions = Set<CIAnyCancellable>()
    var valuePublisher = ValuePublisher<String>("init_value")
    @PublishedValue
    var publishedValue: String = ""
    var label: UILabel!
    var userObservable = UserInfo(id: 1, name: "abc")
    var observer1 = ObserverClass(name: "Observer 1")
    var observer2 = ObserverClass(name: "Observer 2")
    var observer3 = ObserverClass(name: "Observer 3")
    let selectorNotifier = SelectorNotifier<TapEvent>()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        
        self.valuePublisher.subscribe { [weak self] value in
            self?.label?.text = value
        }.store(in: &subscriptions)
        
        self.$publishedValue.subscribe { [weak self] value in
            self?.label?.text = value
        }.store(in: &subscriptions)
        
        self.userObservable.addObserver(observer1)
        self.userObservable.addObserver(observer2)
        self.userObservable.addObserver(observer3)
        self.userObservable.removeObserver(observer3)
        
        self.selectorNotifier.addTarget(self, selector: #selector(onSelectorNotification(_:)), .onTap)
        
        XListView(views: [
            UI.label(text: "").also { self.label = $0 },
            
            UI.stackView(axis: .horizontal, spacing: 10, views: [
                UI.button("Value publisher", onTap: { [weak self] in
                    self?.valuePublisher.send(String.random(count: 10))
                }),
                UI.button("Property wrapper", onTap: { [weak self] in
                    self?.publishedValue = String.random(count: 5)
                }),
            ]),
            
            UI.button("Observable object", onTap: { [weak self] in
                self?.userObservable.changeName()
            }),
            
            UI.button("Selector notification", onTap: { [weak self] in
                self?.selectorNotifier.notify(with: .onTap, String.random(count: 10).toNSString)
            }),
            
        ]).add(toParentView: self.view)
    }
    
    @objc func onSelectorNotification(_ obj: AnyObject?) {
        print("Selector notification: \(obj?.description ?? "nil")")
    }

    protocol NameObserver {
        func nameChanged(_ name: String)
    }

    class ObserverClass: NameObserver {
        let name: String
        init(name: String) {
            self.name = name
        }
        func nameChanged(_ data: String) {
            print("Notified in `\(self.name)` with data `\(data)`")
        }
    }
    
    class UserInfo : CIObservableImplemented {
        typealias Observer = NameObserver
        var observers: ObserversNotifier<Observer> = .init()
        var id: Int
        var name: String
        
        init(id: Int, name: String) {
            self.id = id
            self.name = name
        }
        
        func changeName() {
            let name = String.random(count: 10)
            self.name = name
            self.observers.notifyEachObserver { observer in
                observer.nameChanged(name)
            }
        }
        
        /*
        private let observers = ObserversNotifier<Observer>()
        func addObserver(_ observer: any Observer) {
            self.observers.addObserver(observer)
        }
        func removeObserver(_ observer: any Observer) {
            self.observers.removeObserver(observer)
        } */
    }
    
}


// Protocol problem
/*
class ValueHolder<Value: AnyObject> {
    var value: Value? = nil
    init(_ value: Value? = nil) { self.value = value }
    func setValue(_ value: Value?) { self.value = value }
}

protocol ValueProtocol: AnyObject {
    func valueInfo()
}

class SomeValue: ValueProtocol {
    func valueInfo() {
        print("Some info")
    }
}

class TestValue {
    func test() {
        let value: any ValueProtocol = SomeValue()
        let holder1 = ValueHolder(value)
        let holder2 = ValueHolder<ValueProtocol>()
        holder1.setValue(value)
        holder2.setValue(value)
    }
}

// */
