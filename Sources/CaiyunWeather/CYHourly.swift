//
//  CYHourly.swift
//  
//
//  Created by 袁林 on 2021/6/14.
//

import Foundation

public struct CYHourly: Codable, Equatable {
    
    public let responseStatus: String
    public let description: String
    public let phenomenon: [Phenomenon]
    public let temperature: [Temperature]
    public let precipitation: [Precipitation]
    public let cloudrate: [Cloudrate]
    public let humidity: [Humidity]
    public let pressure: [Pressure]
    public let wind: [Wind]
    public let visibility: [Visibility]
    public let dswrf: [DSWRF]
    public let airQuality: AirQuality
    
    private enum CodingKeys: String, CodingKey {
        case responseStatus = "status"
        case description
        case phenomenon = "skycon"
        case temperature
        case precipitation
        case cloudrate
        case humidity
        case pressure
        case wind
        case visibility
        case dswrf
        case airQuality = "air_quality"
    }
}

extension CYHourly {
    public struct AirQuality: Codable, Equatable {
        let aqi: [AQI]
        let pm25: [PM25]
    }
    
    public struct Wind: Codable, Equatable {
        /// 时间
        public let datetime: Date
        /// 值
        public let value: CYContent.Wind
        
        private enum CodingKeys: String, CodingKey {
            case datetime
            case speed
            case direction
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let datetimeRaw = try container.decode(String.self, forKey: .datetime)
            datetime = DateFormatter.serverType.date(from: datetimeRaw) ?? Date()
            
            let speed = try container.decode(Double.self, forKey: .speed)
            let direction = try container.decode(Double.self, forKey: .direction)
            value = CYContent.Wind(speed: speed, direction: direction)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            let datetimeRaw = DateFormatter.serverType.string(from: datetime)
            try container.encode(datetimeRaw, forKey: .datetime)
            
            try container.encode(value.speed, forKey: .speed)
            try container.encode(value.direction, forKey: .direction)
        }
    }
}

extension CYHourly {
    public typealias HourlyContentDouble = CYContent.ValueWithDatetime<Double>
    
    public typealias Phenomenon = CYContent.ValueWithDatetime<CYContent.Phenomenon>
    public typealias Temperature = HourlyContentDouble
    public typealias Precipitation = HourlyContentDouble
    public typealias Cloudrate = HourlyContentDouble
    public typealias Humidity = HourlyContentDouble
    public typealias Pressure = HourlyContentDouble
    public typealias Visibility = HourlyContentDouble
    public typealias DSWRF = HourlyContentDouble
    public typealias AQI = CYContent.ValueWithDatetime<CYContent.AQI>
    public typealias PM25 = HourlyContentDouble
}
