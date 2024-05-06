import Foundation

protocol CICancellable: Hashable {
    func cancel()
}

class CIAnyCancellable: CICancellable {

    private var cancelAction: (() -> Void)?

    init(_ cancelAction: @escaping () -> Void) {
        self.cancelAction = cancelAction
    }
    
    deinit {
        cancelAction?()
    }

    func store<C>(in collection: inout C) where C : RangeReplaceableCollection, C.Element == CIAnyCancellable {
        collection.append(self)
    }

    func store(in set: inout Set<CIAnyCancellable>) {
        set.insert(self)
    }
    
    func cancel() {
        cancelAction?()
        cancelAction = nil
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    public static func == (lhs: CIAnyCancellable, rhs: CIAnyCancellable) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}

