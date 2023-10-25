//
//  Publisher.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//


import Foundation
import Combine

// decode helper extension
@available(iOS 13.0, *)
@available(macOS 10.15, *)
extension Publisher where Output == Data {
    func decode<T>(_ type: T.Type) -> Publishers.Decode<Self, T, JSONDecoder> {
        decode(type: T.self, decoder: JSONDecoder())
    }
}

@available(iOS 13.0, *)
// parse helper
@available(macOS 10.15, *)
extension Publisher where Output == (data: Data, response: URLResponse) {
    func parse(for request: URLRequest, router: NetworkingRouter) -> Publishers.TryMap<Self, (data: Data, response: URLResponse)> {
        return tryMap { response -> (data: Data, response: URLResponse) in
            try ResponseParser(result: response).parse(for: request, router: router)
            return response
        }
    }
}

