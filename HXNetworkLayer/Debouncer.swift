public class Debouncer {
    private var hx_workItem: DispatchWorkItem?
    private let hx_delay: TimeInterval
 
    public init(delay: TimeInterval = 0.5) {
        self.hx_delay = delay
    }
 
    public func debounce(_ action: @escaping () -> Void) {
        hx_workItem?.cancel()
        let newWorkItem = DispatchWorkItem(block: action)
        hx_workItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + hx_delay, execute: newWorkItem)
    }
}
