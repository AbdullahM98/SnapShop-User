import Foundation
import Reachability
import Combine
import Network

class NetworkMonitor: ObservableObject {
    private var reachability: Reachability?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isConnected: Bool = true
    private var monitor: NWPathMonitor
    private var queue: DispatchQueue
    
    @Published var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: self.queue)
        setupReachability()
        startMonitoring()
        self.monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
                self.connectionType = self.getConnectionType(path)
            }
        }
    }

    
    deinit {
        self.monitor.cancel()
        reachability?.stopNotifier()
    }
    
    private func getConnectionType(_ path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else {
            return .unknown
        }
    }
    

    
    private func setupReachability() {
        reachability = try? Reachability()
        
        reachability?.whenReachable = { [weak self] reachability in
            DispatchQueue.main.async {
                self?.isConnected = true
             //   self?.showSnackbarIfNeeded(isConnected: true)
                UserDefaults.standard.set(true, forKey: Support.isConnected)
            }
        }
        
        reachability?.whenUnreachable = { [weak self] _ in
            DispatchQueue.main.async {
                self?.isConnected = false
                self?.showSnackbarIfNeeded(isConnected: false)
                UserDefaults.standard.set(false, forKey: Support.isConnected)

            }
        }
    }
    
    private func startMonitoring() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    func checkConnectivity() {
        if let reachability = reachability {
            DispatchQueue.main.async {
                self.isConnected = (reachability.connection != .unavailable)
            }
        }
    }
    
    private func showSnackbarIfNeeded(isConnected:Bool) {
        SnackBarHelper.showSnackBar( isConnected: isConnected)
    }
    
 
}
