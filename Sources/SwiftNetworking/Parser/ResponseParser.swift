//
//  ResponseParser.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//

import Foundation

struct ResponseParser {
    let result: (data: Data, response: URLResponse)
    
    // parse the data from response
    func parse(for request: URLRequest, router: NetworkingRouter) throws {
        guard let urlResponse = result.response as? HTTPURLResponse else { assertionFailure(); return }
        guard !(200...299 ~= urlResponse.statusCode) else { return }
        throw NetworkingError(.invalidStatusCode(urlResponse.statusCode), result: result, request: request, router: router)
    }
}
