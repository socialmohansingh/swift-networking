//
//  HTTPMethod.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//

import Foundation

/// The web http request methods
public enum HTTPMethod {
    
    case get, post, put, delete, patch
    
    var identifier: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .patch: return "PATCH"
        }
    }
}

