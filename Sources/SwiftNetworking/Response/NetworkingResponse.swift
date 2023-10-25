//
//  NetworkingResponse.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//

import Foundation

public struct NetworkingResponse {
    public let data: Data
    public let urlRequest: URLRequest
    public let urlResponse: URLResponse?
    public let router: NetworkingRouter
    public let statusCode: Int
    
    static func networkResponse(for router: NetworkingRouter, data: Data, request: URLRequest, response: URLResponse) -> NetworkingResponse {
        guard let urlResponse = response as? HTTPURLResponse else {
            return NetworkingResponse(data: data, urlRequest: request, urlResponse: response, router: router, statusCode: 0)
        }
        return NetworkingResponse(data: data, urlRequest: request, urlResponse: response, router: router, statusCode: urlResponse.statusCode)
    }
}

