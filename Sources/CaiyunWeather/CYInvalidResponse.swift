//
//  CYInvalidResponse.swift
//  
//
//  Created by 袁林 on 2021/6/12.
//

import Foundation

struct CYInvalidResponse: Codable {
    /// 状态
    let status: String
    /// 错误信息
    let error: String
    /// API 版本
    let version: String
    
    private enum CodingKeys: String, CodingKey {
        case status
        case error
        case version = "api_version"
    }
}
