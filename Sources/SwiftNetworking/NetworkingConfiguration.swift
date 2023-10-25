//
//  NetworkingConfiguration.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//


import Foundation

public struct NetworkingConfiguration {
    
    /// The baseURL for the API
    let baseURL: String
    
    /// The url session connfiguration
    let sessionConfiguration: URLSessionConfiguration
    
    /// The request interceptor
    let interceptor: RequestInterceptor?
    
    // The response adapter
    let adapter: ResponseAdaptable?
    
    public init(baseURL: String, sessionConfiguration: URLSessionConfiguration = URLSessionConfiguration.default, interceptor: RequestInterceptor? = nil, adapter: ResponseAdaptable? = nil) {
        self.baseURL = baseURL
        self.sessionConfiguration = sessionConfiguration
        self.interceptor = interceptor
        self.adapter = adapter
    }
    
    /// The configuration information
    public func debugInfo() -> [String: Any] {
        [
            "baseURL": baseURL,
            "sessionConfiguration": sessionConfiguration,
            "interceptors": interceptor ?? "",
            "adapter": adapter ?? ""
        ]
    }
}

