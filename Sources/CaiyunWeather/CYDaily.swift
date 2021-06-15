//
//  CYDaily.swift
//  
//
//  Created by 袁林 on 2021/6/14.
//

import Foundation

public struct CYDaily: Codable, Equatable {
    
    public let responseStatus: String
    //public let astronomy: [Astronomy]
    public let phenomenon: [Phenomenon]
    public let phenomenonDaytime: [Phenomenon]
    public let phenomenonNighttime: [Phenomenon]
    public let temperature: [Temperature]
    public let precipitation: [Precipitation]
    public let pressure: [Pressure]
    public let wind: [Wind]
    public let cloudrate: [Cloudrate]
    public let humidity: [Humidity]
    public let dswrf: [DSWRF]
    public let visibility: [Visibility]
    //public let airQuality: AirQuality
    //public let lifeIndex: LifeIndex
    
    private enum CodingKeys: String, CodingKey {
        case responseStatus = "status"
        //case astronomy = "astro"
        case phenomenon = "skycon"
        case phenomenonDaytime = "skycon_08h_20h"
        case phenomenonNighttime = "skycon_20h_32h"
        case temperature
        case precipitation
        case pressure
        case wind
        case cloudrate
        case humidity
        case dswrf
        case visibility
        //case airQuality = "air_quality"
        //case lifeIndex = "life_index"
    }
}

// MARK: - Redefined Types

extension CYDaily {
    
}

// MARK: - Type Alias

extension CYDaily {
    public typealias DailyContentDouble = AverageAndExtremumWithDate<Double>
    
    public typealias Phenomenon = ValueWithDate<CYContent.Phenomenon>
    public typealias Temperature = DailyContentDouble
    public typealias Precipitation = DailyContentDouble
    public typealias Pressure = DailyContentDouble
    public typealias Wind = AverageAndExtremumWithDate<CYContent.Wind>
    public typealias Cloudrate = DailyContentDouble
    public typealias Humidity = DailyContentDouble
    public typealias DSWRF = DailyContentDouble
    public typealias Visibility = DailyContentDouble
    
    // Airquality
    // lifeindex
    // Astronomy
}

// MARK: - Abstract Types

extension CYDaily {
    
    public struct ValueWithDate<T: Codable & Equatable>: Codable, Equatable {
        /// 时间
        public let datetime: CYContent.DatetimeServerType
        /// 值
        public let value: T
        
        private enum CodingKeys: String, CodingKey {
            case datetime = "date"
            case value
        }
    }
    
    public struct AverageAndExtremumWithDate<T: Codable & Equatable>: Codable, Equatable {
        /// 时间
        public let datetime: CYContent.DatetimeServerType
        /// 值
        public let value: CYContent.AverageAndExtremum<T>
        
        private enum CodingKeys: String, CodingKey {
            case datetime = "date"
            case average = "avg"
            case maximum = "max"
            case minimum = "min"
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            datetime = try container.decode(CYContent.DatetimeServerType.self, forKey: .datetime)
            
            let average = try container.decode(T.self, forKey: .average)
            let maximum = try container.decode(T.self, forKey: .maximum)
            let minimum = try container.decode(T.self, forKey: .minimum)
            value = CYContent.AverageAndExtremum<T>(average: average, maximum: maximum, minimum: minimum)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(datetime, forKey: .datetime)
            
            try container.encode(value.average, forKey: .average)
            try container.encode(value.maximum, forKey: .maximum)
            try container.encode(value.minimum, forKey: .minimum)
        }
    }
}

