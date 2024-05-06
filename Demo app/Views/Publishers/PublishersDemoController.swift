import UIKit
import SwiftUI
import Combine

class PublishersDemoController: UIViewController {

    weak var label: UILabel!
    weak var label2: UILabel!
    
    var cancellables = Set<AnyCancellable>()
    var currentValueSubject = CurrentValueSubject<String, Never>("-")
    var publisherPassthrough = PassthroughSubject<String, Never>()
    @Published var publishedProperty: String = "-"
    var asyncIterator = AsyncItemProvider<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        self.createViews()
        
        self.currentValueSubject.sink { [weak self] value in
            guard let self else { return }
            self.label.text = "currentValueSubject: \(value)"
        }.store(in: &cancellables)
        
        self.publisherPassthrough.sink { [weak self] value in
            guard let self else { return }
            self.label.text = "publisherPassthrough: \(value)"
        }.store(in: &cancellables)
        
        self.$publishedProperty.sink { [weak self] value in
            guard let self else { return }
            self.label.text = "publishedProperty: \(value)"
        }.store(in: &cancellables)
        
        DispatchQueue.global().async {
            for value in self.asyncIterator {
                DispatchQueue.main.async {
                    self.label.text = "asyncIterator: \(value)"
                }
            }
            print("Cycle finished")
        }
        
        // filter
        self.currentValueSubject
            .filter { value in
                return value.lowercased().contains("a")
            }
            .sink { value in
                print("Filtered value: \(value)")
            }
            .store(in: &cancellables)
        
        // timer
        Timer.publish(every: 1, on: .main, in: .common)
                    .autoconnect()
                    .sink { [weak self] value in
                        guard let self else { return }
                        self.label2.text = "Timer: \(value)"
                    }
                    .store(in: &cancellables)
        
        /*
        // other
        let justPublisher = Just("Hello, World!")
        let arrayPublisher = Publishers.Sequence<[Int], Never>(sequence: [1, 2, 3, 4, 5])
        let timerPublisher = Timer.publish(every: 1.0, on: .main, in: .common)
        let transformedPublisher = justPublisher.map { $0.count }
        let flatMappedPublisher = arrayPublisher.flatMap { Just($0 * 2) }
        let filteredPublisher = arrayPublisher.filter { $0 % 2 == 0 }
        let combinedPublisher = Publishers.CombineLatest(justPublisher, arrayPublisher)
        let mergedPublisher = Publishers.Merge(justPublisher, arrayPublisher.map { String($0) })
        let zippedPublisher = Publishers.Zip(justPublisher, arrayPublisher)
        */
    }
    
    func createViews() {
        XListView(views: [
            UI.label(text: "").also({
                self.label = $0
            }),
            
            UI.label(text: "").also({
                self.label2 = $0
            }),

            UI.button("currentValueSubject", onTap: { [weak self] in
                guard let self else { return }
                self.currentValueSubject.value = String.random(count: 5)
                //self.currentValueSubject.send(String.random(count: 5))
            }),
            
            UI.button("publisherPassthrough", onTap: { [weak self] in
                guard let self else { return }
                self.publisherPassthrough.send(String.random(count: 5))
            }),
            
            UI.button("publishedProperty", onTap: { [weak self] in
                guard let self else { return }
                self.publishedProperty = String.random(count: 5)
            }),
            
            UI.stackView(axis: .horizontal, spacing: 8, views: [
                UI.button("asyncIterator", onTap: { [weak self] in
                    guard let self else { return }
                    self.asyncIterator.sendNext(String.random(count: 5))
                }),
                UI.button("stop", onTap: { [weak self] in
                    guard let self else { return }
                    self.asyncIterator.sendNext(nil)
                }),
            ]),
            
            UI.button("future value", onTap: { [weak self] in
                guard let self else { return }
                let futurePublisher = Future<String, Never> { promise in
                    DispatchQueue.global().async {
                        Thread.sleep(forTimeInterval: 0.2)
                        promise(.success(String.random(count: 5)))
                    }
                }
                
                futurePublisher.sink { value in
                    DispatchQueue.main.async {
                        self.label.text = "Future value: \(value)"
                    }
                }.store(in: &cancellables)
            }),
            
            
        ]).add(toParentView: self.view)
    }
}
