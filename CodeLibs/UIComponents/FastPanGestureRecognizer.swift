import UIKit

class FastPanGestureRecognizer: UIPanGestureRecognizer, UIGestureRecognizerDelegate {
    
    var initialTouchLocation: CGPoint!
    let minOffset: CGFloat = 3
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        initialTouchLocation = touches.first!.location(in: view)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        if self.state == .possible {
            if distance(touch.location(in: self.view), self.initialTouchLocation) >= minOffset {
                self.state = .changed
            }
        }
    }
    
    private func distance(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let dx = (point2.x - point1.x), dy = (point2.y - point1.y)
        return sqrt(dx*dx + dy*dy)
    }
    
    func useHigherPriority() {
        self.delegate = self
    }
    
    func gestureRecognizer(_: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherRecognizer:UIGestureRecognizer) -> Bool {
        return !(otherRecognizer is UIPanGestureRecognizer)
    }
}
