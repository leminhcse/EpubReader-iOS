//
//  Reachability.swift
//  EpubReader
//
//  Created by mac on 28/08/2022.
//

import Connectivity

public class Reachability {

    public static var shared = Reachability()
    
    var connectivity = Connectivity()
        
    private init() {
        
        connectivity.framework = .network

        // Start listening for changes in Connectivity
        connectivity.startNotifier()
    }
    
    deinit {
        connectivity.stopNotifier()
    }
    
    /// Check if mobile is using wifi (with/without internet)
    ///
    /// - Note: With or without internet
    var isConnectedViaWifi: Bool {
        return connectivity.status == .connectedViaWiFi || connectivity.status == .connectedViaWiFiWithoutInternet
    }
    
    /// Check if mobile is using cellular
    ///
    /// - Note: With or without internet
    var isConnectedViaCellular: Bool {
        return connectivity.status == .connectedViaCellular || connectivity.status == .connectedViaCellularWithoutInternet
    }

    /// Check if network is available
    var isConnectedToNetwork: Bool {
        return connectivity.status == .connected || connectivity.status == .connectedViaWiFi || connectivity.status == .connectedViaCellular
    }
}

extension ConnectivityStatus {
    
    var errorMessage: String {
        switch self {
        case .connectedViaCellularWithoutInternet:
            return "Cellular doesn't have internet connection"
        case .connectedViaWiFiWithoutInternet:
            return "Wifi doesn't have internet connection"
        case .determining:
            return "The internet connection is being determined"
        case .notConnected:
            return "No Internet Connection"
        case .connected, .connectedViaWiFi, .connectedViaCellular, .connectedViaEthernet, .connectedViaEthernetWithoutInternet:
            return "Connected to internet"
        }
    }
}
