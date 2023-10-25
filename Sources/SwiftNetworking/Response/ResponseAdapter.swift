//
//  ResponseAdapter.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//

import Foundation
import Combine

public protocol ResponseAdaptable {
    @available(iOS 13.0, *)
    @available(macOS 10.15, *)
    func adapt(router: NetworkingRouter, error: NetworkingError) throws -> AnyPublisher<NetworkingResponse, NetworkingError>
    func adapt(router: NetworkingRouter, response: NetworkingResponse)
}

public extension ResponseAdaptable {
    func adapt(router: NetworkingRouter, response: NetworkingResponse) {}
}

