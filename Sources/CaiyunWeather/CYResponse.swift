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
    public let serverTimeZone: TimeZone
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
        case serverTimeZoneShift = "tzshift"
        case result
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        responseStatus = try container.decode(String.self, forKey: .responseStatus)
        version = try container.decode(String.self, forKey: .version)
        apiStatus = try container.decode(String.self, forKey: .apiStatus)
        language = try container.decode(String.self, forKey: .language)
        unit = try container.decode(String.self, forKey: .unit)
        serverTime = try container.decode(CYContent.Datetime1970Based.self, forKey: .serverTime)
        
        let locationRaw = try container.decode([Double].self, forKey: .coordinate)
        coordinate = .init(fromArray: locationRaw)
        
        let serverTimeShiftRaw = try container.decode(Int.self, forKey: .serverTimeZoneShift)
        serverTimeZone = TimeZone(secondsFromGMT: serverTimeShiftRaw)!
        
        result = try container.decode(CYResult.self, forKey: .result)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(responseStatus, forKey: .responseStatus)
        try container.encode(version, forKey: .version)
        try container.encode(apiStatus, forKey: .apiStatus)
        try container.encode(language, forKey: .language)
        try container.encode(unit, forKey: .unit)
        try container.encode(serverTime, forKey: .serverTime)
        
        try container.encode(coordinate.array, forKey: .coordinate)
        
        let serverTimeShiftRaw = serverTimeZone.secondsFromGMT()
        try container.encode(serverTimeShiftRaw, forKey: .serverTimeZoneShift)
        
        try container.encode(result, forKey: .result)
    }
}
