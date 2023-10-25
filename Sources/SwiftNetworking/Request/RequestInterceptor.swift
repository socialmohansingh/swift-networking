//
//  RequestInterceptor.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//


import Foundation

public protocol RequestInterceptor {
    func intercept(request: inout URLRequest, router: NetworkingRouter) throws
    func interceptParams(params: Parameters?) -> Parameters?
}

public extension RequestInterceptor {
    func interceptParams(params: Parameters?) -> Parameters? {
        return params
    }
}

