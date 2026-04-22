public class Debouncer {
    private var hx_workItem: DispatchWorkItem?
    private var hx_timer: DispatchSourceTimer?

    
    // 原有的防抖功能
    public func debounce(_ hx_delay: TimeInterval = 0.5, action: @escaping () -> Void) {
        hx_workItem?.cancel()
        let newWorkItem = DispatchWorkItem(block: action)
        hx_workItem = newWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + hx_delay, execute: newWorkItem)
    }
    
    // 新增：倒计时
    public func hx_countdown(_ seconds: Int = 60, completion: ((Bool, Int) -> Void)? = nil) {
        // 取消已有的倒计时
        cancelCountdown()
        
        var count = seconds
        
        let timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        timer.schedule(deadline: .now(), repeating: .seconds(1))
        timer.setEventHandler { [weak self] in
            if count == 0 {
                self?.cancelCountdown()
            } else {
                count -= 1
            }
            DispatchQueue.main.async {
                completion?(count == 0, count)
            }
        }
        timer.activate()
        hx_timer = timer
    }
    
    // 取消倒计时
    func cancelCountdown() {
        hx_timer?.cancel()
        hx_timer = nil
    }
    
    // 取消所有任务（防抖 + 倒计时）
    func cancelAll() {
        hx_workItem?.cancel()
        hx_workItem = nil
        cancelCountdown()
    }
}
