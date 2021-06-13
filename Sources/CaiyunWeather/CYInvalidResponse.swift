//
//  CYInvalidResponse.swift
//  
//
//  Created by 袁林 on 2021/6/12.
//

import Foundation

struct CYInvalidResponse: Codable {
    
    // {"status":"failed", "error":"'token is invalid'", "api_version":"v2.5"}
    
    let status: String
    let error: String
    let version: String
    
    private enum CodingKeys: String, CodingKey {
        case status
        case error
        case version = "api_version"
    }
}
