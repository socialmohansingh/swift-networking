//
//  RequestBuilder.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//


import Foundation

/// The struct for building the request with information from router
struct RequestBuilder {
    
    /// The router of the request
    let router: NetworkingRouter
    
    /// The session config
    let config: NetworkingConfiguration
    
    /// Gets the request with config and router info
    /// - Returns: The URLResquest to use
    func getRequest() throws -> URLRequest {
        let baseURL = router.overridenBaseURL ?? config.baseURL
        guard let url = URL(string: baseURL)?.appendingPathComponent(router.path) else {
            throw NetworkingError(.invalidBaseURL)
        }
        var request = URLRequest(url: url)
        request.httpMethod = router.httpMethod.identifier
        router.headers.forEach({ request.addValue($0, forHTTPHeaderField: $1) })
        try router.encoder.forEach { type in
            switch type {
            case .json(let params):
                let requiredParameters = config.interceptor?.interceptParams(params: params)
                try request.jsonEncoding(requiredParameters)
            case .url(let params):
                let requiredParameters = config.interceptor?.interceptParams(params: params)
                try request.urlEncoding(requiredParameters)
            }
        }
        
        // let the interceptor handle extra request settings
        try config.interceptor?.intercept(request: &request, router: router)
        
        return request
    }
}

