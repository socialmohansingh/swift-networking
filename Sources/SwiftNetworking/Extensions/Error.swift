//
//  Error.swift
//  
//
//  Created by Mohan Singh Thagunna on 25/10/2023.
//


import Foundation

extension Error {
    public var errorCode:Int {
        return (self as NSError).code
    }
}

