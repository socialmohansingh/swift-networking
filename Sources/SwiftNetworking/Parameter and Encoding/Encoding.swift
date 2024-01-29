//
//  Encoding.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//

import Foundation

public enum EncoderType {
    case json(Parameters?)
    case url(Parameters?)
}

// MARK: Sets the parameter as json object to body of the request
extension URLRequest {
    mutating public func jsonEncoding(_ parameters: Parameters?) throws {
        guard let params = parameters else { return }
        do {
            let data = try JSONSerialization.data(withJSONObject: params, options: .sortedKeys)
            httpBody = data
            setValue("application/json", forHTTPHeaderField: "Content-Type")
        } catch {
            throw NetworkingError(.jsonEncodingFailed(error))
        }
    }
}

// MARK: Sets the params as the url query string if the supported methods are used or add to body otherwise
extension URLRequest {
    
    mutating public func urlEncoding(_ parameters: Parameters?) throws {
        guard let params = parameters else { return }
        if let method = httpMethod, supportsURLQuery(method: method), let requestURL = url {
            if var urlComponents = URLComponents(url: requestURL ,resolvingAgainstBaseURL: false) {
                var queryItems = urlComponents.queryItems ?? [URLQueryItem]()
                params.forEach { param in
                    if let array = param.value as? [CustomStringConvertible] {
                        array.forEach {
                            queryItems.append(URLQueryItem(name: "\(param.key)[]", value: "\($0)"))
                        }
                    }
                    queryItems.append(URLQueryItem(name: param.key, value: "\(param.value)"))
                }
                urlComponents.queryItems = queryItems
                url = urlComponents.url
            }
        } else {
            httpBody = params.percentEncoded().data(using: .utf8)
            setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
    }
    
    private func supportsURLQuery(method: String) -> Bool {
        let supportedValues = [HTTPMethod.get, HTTPMethod.delete].map({$0.identifier})
        return supportedValues.contains(method)
    }
}
