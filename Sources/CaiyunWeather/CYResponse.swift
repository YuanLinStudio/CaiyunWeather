//
//  CYResponse.swift
//  
//
//  Created by 袁林 on 2021/6/13.
//

import Foundation

public struct CYResponse: Codable, Equatable {
    /// 响应状态
    public let responseStatus: String
    /// API 版本
    public let version: String
    /// API 状态
    public let apiStatus: String
    /// 请求语言
    public let language: String
    /// 单位制
    public let unit: String
    /// 返回点坐标
    public let coordinate: CYCoordinate
    /// 服务器时间
    public let serverTime: CYContent.Datetime1970Based
    /// 服务器时区
    public let serverTimeZone: CYTimeZone
    /// 返回结果对象
    public let result: CYResult
    
    private enum CodingKeys: String, CodingKey {
        case responseStatus = "status"
        case version = "api_version"
        case apiStatus = "api_status"
        case language = "lang"
        case unit
        case coordinate = "location"
        case serverTime = "server_time"
        case serverTimeZone = "tzshift"
        case result
    }
}

// MARK: - Redefined Types

extension CYResponse {
    
    public struct CYTimeZone: Codable, Equatable {
        /// 值
        public let value: TimeZone
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            let serverTimeShiftRaw = try container.decode(Int.self)
            value = TimeZone(secondsFromGMT: serverTimeShiftRaw)!
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            let serverTimeShiftRaw = value.secondsFromGMT()
            try container.encode(serverTimeShiftRaw)
        }
    }
}
