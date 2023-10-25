//
//  NetworkingError.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//

import Foundation

enum NetworkErrorType {
    case networkingNotInitialized
    case invalidBaseURL
    case jsonEncodingFailed(Error)
    case noConnectivity
    case invalidStatusCode(Int)
}

public struct NetworkingError: LocalizedError {
    
    private let reason: String
    public let code: Int
    public let result: (data: Data, response: URLResponse)?
    public let request: URLRequest?
    public let router: NetworkingRouter?
    
    init(_ reason: String, result: (data: Data, response: URLResponse)? = nil, request: URLRequest? = nil, router: NetworkingRouter? = nil) {
        self.reason = reason
        self.code = 0
        self.result = result
        self.request = request
        self.router = router
    }
    
    init(_ urlError: URLError, result: (data: Data, response: URLResponse)? = nil, request: URLRequest? = nil, router: NetworkingRouter? = nil) {
        self.reason = urlError.localizedDescription
        self.code = urlError.code.rawValue
        self.result = result
        self.request = request
        self.router = router
    }
    
    init(_ error: Error, result: (data: Data, response: URLResponse)? = nil, request: URLRequest? = nil, router: NetworkingRouter? = nil) {
        if let netError = error as? NetworkingError {
            self.reason = netError.reason
            self.code = netError.code
            self.result = netError.result
            self.request = netError.request
            self.router = netError.router
        } else {
            self.reason = error.localizedDescription
            self.code = error.errorCode
            self.result = result
            self.request = request
            self.router = router
        }
    }
    
    init(_ type: NetworkErrorType, result: (data: Data, response: URLResponse)? = nil, request: URLRequest? = nil, router: NetworkingRouter? = nil) {
        
        switch type {
        case .networkingNotInitialized:
            self.code = 0
            self.reason = "The Networking class is not initialized with required configuration. Please make sure to initialize the Networking once when the app starts."
        case .invalidBaseURL:
            self.code = 0
            self.reason = "The provided base url is invalid or not properly constructed as url"
        case .jsonEncodingFailed(let error):
            self.code = 0
            self.reason = "Failed to encode parameters to JSON \(error.localizedDescription)"
        case .noConnectivity:
            self.code = 0
            self.reason = "A data connection cannot be made at the moment. Please check your network connection and try again."
        case .invalidStatusCode( let code):
            self.reason = ""
            self.code = code
        }
        self.result = result
        self.request = request
        self.router = router
    }
    
    public var errorDescription: String? {
        return reason
    }
    
    public func networkingResponse() -> NetworkingResponse? {
        guard let request = request, let router = router else { return nil }
        return NetworkingResponse(data: self.result?.data ?? Data(), urlRequest: request, urlResponse: self.result?.response, router: router, statusCode: code)
    }
}

