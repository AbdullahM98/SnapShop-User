import Foundation
import Reachability
import Combine

class NetworkMonitor: ObservableObject {
    private var reachability: Reachability?
    private var cancellables = Set<AnyCancellable>()
    
    @Published var isConnected: Bool = true
    
    init() {
        setupReachability()
        startMonitoring()
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
    
    deinit {
        reachability?.stopNotifier()
    }
}
