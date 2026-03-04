
import Foundation

class SwitchHostAddress
{
    let hosts = SharedModel.shared.hx_constactValue?[hostPrefix] as? [String] ?? []
    
    static let shared = SwitchHostAddress()
    
    private var hx_switchTimes: Int!
    
    private var hx_isExcuting: Bool = false
    
    private let hx_lock = NSLock()
    
    let hx_hostAddress = "hostAddress"
    
    private var hostAddress = ""
    
    private var hx_requestHost = ""
    
    init() {
        hx_switchTimes = hosts.count
        hx_config()
    }
    
    private func hx_config(){
        let hx_standard = UserDefaults.standard
        
        if let address = hx_standard.string(forKey: hx_hostAddress) {
            hostAddress = address
        }else{
            requestApiHost()
        }
    }
    
    func requestApiHost() {
        
        print("hx_host enter")

        hx_lock.lock()
        defer {
            print("hx_host out")
            hx_lock.unlock()
        }
        
        if !hx_isExcuting {
            hx_isExcuting = true
            hx_switchTimes = hosts.count

            if hx_switchAddress() {
                getApi()
            }
        }
    }
    
    
    private func hx_switchAddress() -> Bool {
        if  hx_switchTimes > 0 {
            if let index = hosts.firstIndex(of: hx_requestHost) {
                hx_requestHost = hosts[(index + 1) % hosts.count]
            }else{
                hx_requestHost = hosts.first!
            }
            hx_switchTimes -= 1
            print("hx_host switchAddress : \(hx_requestHost)")
            return true
        }
        hx_lock.lock()
        print("hx_host out")
        hx_isExcuting = false
        LoadingIndicator.hx_show(hx_commonDoc("a54"))
        hx_lock.unlock()
        return false
    }
    
    func addresss() -> String {
        return hostAddress
    }
    
    private func getApi() {
        
        if let url = URL(string: hx_requestHost) {
            LoadingIndicator.hx_show()
            let configure = URLSessionConfiguration.default
            configure.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
            let session = URLSession(configuration:  configure)
            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
                LoadingIndicator.hx_hide()
                guard let strongSelf = self else {
                    return
                }
                
                guard let data = data, error == nil else {
                    print("host request failed :  " + strongSelf.hx_requestHost)
                    if strongSelf.hx_switchAddress() {
                        strongSelf.getApi()
                    }
                    return
                }
                let contentStr = String(data: data, encoding: .utf8)
                if let content = contentStr, !content.isEmpty {
                    
                    var separator = "ba2f7f"
                    if !hostPrefix.contains("test") {
                        separator = "pa2f7t"
                    }
                    
                    if let host = content.components(separatedBy: separator).dropFirst().first {
                        
                        strongSelf.hx_lock.lock()
                        
                        strongSelf.hostAddress = hostPrefix + host
                        let hx_standard = UserDefaults.standard
                        hx_standard.setValue(strongSelf.hostAddress, forKey: strongSelf.hx_hostAddress)
                        hx_standard.synchronize()
                        
                        print("host out \(strongSelf.hostAddress)")
                        strongSelf.hx_isExcuting = false
                        strongSelf.hx_lock.unlock()
                        
                    }else{
                        print("host splite failed :  " + url.absoluteString + "\n" + content)
                        if strongSelf.hx_switchAddress() {
                            strongSelf.getApi()
                        }
                    }
                }else{
                    print("host splite failed :  "  + url.absoluteString)
                    if strongSelf.hx_switchAddress() {
                        strongSelf.getApi()
                    }
                }
            }
            task.resume()
        }
    }
}
