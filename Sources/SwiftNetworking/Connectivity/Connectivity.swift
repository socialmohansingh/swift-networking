//
//  Connectivity.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//


import Foundation
import Combine

public enum ConnectivityStatus {
    case connected, disconnected, unknown
}

@available(iOS 13.0, *)
@available(macOS 10.15, *)
open class Connectivity {
    
    /// The shared instance of this class as it needs to be available throught the projects lifetime
    public static let shared = Connectivity()
    private init() {}
    
    /// The trigger when the connectivity status is changed
    public let stateTrigger = CurrentValueSubject<ConnectivityStatus, Never>(.unknown)
    
    /// value for the current connectivity status
    public var status: ConnectivityStatus { getCUrrentConnectivityStatus() }
    
    /// Method to get the current connectivity status
    /// - Returns: Current connectivity status
    private func getCUrrentConnectivityStatus() -> ConnectivityStatus {
        return .connected
    }
}

