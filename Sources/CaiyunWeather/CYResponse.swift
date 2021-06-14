//
//  CYResponse.swift
//  
//
//  Created by 袁林 on 2021/6/13.
//

import Foundation

public struct CYResponse: Codable {
    
    public let responseStatus: String
    public let version: String
    public let apiStatus: String
    public let language: String
    public let unit: String
    public let coordinate: CYCoordinate
    public let serverTime: Date
    public let serverTimeZone: TimeZone
    //public let result: CYResult
    
    private enum CodingKeys: String, CodingKey {
        case responseStatus = "status"
        case version = "api_version"
        case apiStatus = "api_status"
        case language = "lang"
        case unit
        case coordinate = "location"
        case serverTime = "server_time"
        case serverTimeZoneShift = "tzshift"
        //case result
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        responseStatus = try container.decode(String.self, forKey: .responseStatus)
        version = try container.decode(String.self, forKey: .version)
        apiStatus = try container.decode(String.self, forKey: .apiStatus)
        language = try container.decode(String.self, forKey: .language)
        unit = try container.decode(String.self, forKey: .unit)
        
        let locationRaw = try container.decode([Double].self, forKey: .coordinate)
        coordinate = .init(fromArray: locationRaw)
        
        let serverTimeRaw = try container.decode(Int.self, forKey: .serverTime)
        serverTime = Date(timeIntervalSince1970: TimeInterval(serverTimeRaw))
        
        let serverTimeShiftRaw = try container.decode(Int.self, forKey: .serverTimeZoneShift)
        serverTimeZone = TimeZone(secondsFromGMT: serverTimeShiftRaw)!
        
        //result = try container.decode(CYResult.self, forKey: .result)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(responseStatus, forKey: .responseStatus)
        try container.encode(version, forKey: .version)
        try container.encode(apiStatus, forKey: .apiStatus)
        try container.encode(language, forKey: .language)
        try container.encode(unit, forKey: .unit)
        
        try container.encode(coordinate.array, forKey: .coordinate)
        
        let serverTimeRaw = Int(serverTime.timeIntervalSince1970)
        try container.encode(serverTimeRaw, forKey: .serverTime)
        
        let serverTimeShiftRaw = serverTimeZone.secondsFromGMT()
        try container.encode(serverTimeShiftRaw, forKey: .serverTimeZoneShift)
        
        //try container.encode(result, forKey: .result)
    }
}
