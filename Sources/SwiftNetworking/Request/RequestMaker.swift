//
//  RequestMaker.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//


import Foundation
import Combine

struct RequestMaker {
    private let router: NetworkingRouter
    private let config: NetworkingConfiguration
    
    init(router: NetworkingRouter, config: NetworkingConfiguration) {
        self.router = router
        self.config = config
    }
    
    @available(iOS 13.0, *)
    @available(macOS 10.15, *)
    func makeDataRequest() -> AnyPublisher<NetworkingResponse, NetworkingError> {
        do {
            let request = try RequestBuilder(router: router, config: config).getRequest()
            let session = URLSession(configuration: config.sessionConfiguration)
            if let adapter = config.adapter {
                return adaptedRequest(session, adapter: adapter, request: request)
            }
            return normalRequest(session, request: request)
        } catch {
            return Fail<NetworkingResponse, NetworkingError>(error: NetworkingError(error)).eraseToAnyPublisher()
        }
    }
    @available(iOS 13.0, *)
    
    @available(macOS 10.15, *)
    private func adaptedRequest(_ session: URLSession, adapter: ResponseAdaptable, request: URLRequest) -> AnyPublisher<NetworkingResponse, NetworkingError> {
        return session.dataTaskPublisher(for: request)
            .parse(for: request, router: router)
            .mapError({ NetworkingError.init($0, result: nil, request: request, router: self.router) })
            .tryCatch { error -> AnyPublisher<(data: Data, response: URLResponse), NetworkingError> in
                try adapter.adapt(router: router, error: error)
                    .flatMap { _ in
                        session.dataTaskPublisher(for: request).parse(for: request, router: router).mapError({ NetworkingError.init($0, result: nil, request: request, router: self.router) })
                    }.eraseToAnyPublisher()
            }.mapError({ NetworkingError.init($0, result: nil, request: request, router: self.router) }).map({ data, response -> NetworkingResponse in
                let response = NetworkingResponse.networkResponse(for: router, data: data, request: request, response: response)
                adapter.adapt(router: router, response: response)
                return response
            }).eraseToAnyPublisher()
    }
    
    @available(iOS 13.0, *)
    @available(macOS 10.15, *)
    private func normalRequest(_ session: URLSession, request: URLRequest) -> AnyPublisher<NetworkingResponse, NetworkingError> {
        return session.dataTaskPublisher(for: request).parse(for: request, router: router).mapError({ NetworkingError($0) }).map({ data, response -> NetworkingResponse in
            let response = NetworkingResponse.networkResponse(for: router, data: data, request: request, response: response)
            return response
        }).eraseToAnyPublisher()
    }
}

