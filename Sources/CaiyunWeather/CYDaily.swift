//
//  CYDaily.swift
//  
//
//  Created by 袁林 on 2021/6/14.
//

import Foundation

public struct CYDaily: Codable, Equatable {
    /// 响应状态
    public let responseStatus: String
    /// 日出日落
    public let astronomy: [Astronomy]
    /// 天气现象 - 全天
    public let phenomenon: [Phenomenon]
    /// 天气现象 - 白天
    public let phenomenonDaytime: [Phenomenon]
    /// 天气现象 - 夜晚
    public let phenomenonNighttime: [Phenomenon]
    /// 温度
    public let temperature: [Temperature]
    /// 降水量
    public let precipitation: [Precipitation]
    /// 气压
    public let pressure: [Pressure]
    /// 风
    public let wind: [Wind]
    /// 云量
    public let cloudrate: [Cloudrate]
    /// 湿度
    public let humidity: [Humidity]
    /// 短波辐射下向通量
    public let dswrf: [DSWRF]
    /// 能见度
    public let visibility: [Visibility]
    /// 空气质量
    public let airQuality: AirQuality
    /// 生活指数
    public let lifeIndex: LifeIndex
    
    private enum CodingKeys: String, CodingKey {
        case responseStatus = "status"
        case astronomy = "astro"
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
        case airQuality = "air_quality"
        case lifeIndex = "life_index"
    }
}

// MARK: - Redefined Types

extension CYDaily {
    
    public struct Astronomy: Codable, Equatable {
        /// 日期
        public let date: CYContent.DatetimeServerType
        /// 值
        public let value: Content
        
        private enum CodingKeys: String, CodingKey {
            case date
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            date = try container.decode(CYContent.DatetimeServerType.self, forKey: .date)
            value = try Content(from: decoder)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(date, forKey: .date)
            try value.encode(to: encoder)
        }
        
        public struct Content: Codable, Equatable {
            /// 日出
            public let sunrise: AstronomyTime
            /// 日落
            public let sunset: AstronomyTime
            /// 时间（仅供 encoding 使用，外部使用外层的 date 参数）
            private let date: CYContent.DatetimeServerType
            
            private enum CodingKeys: String, CodingKey {
                case date
                case sunrise
                case sunset
            }
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                
                let dateRaw = try container.decode(String.self, forKey: .date)
                date = try container.decode(CYContent.DatetimeServerType.self, forKey: .date)
                
                let sunriseContainer = try container.nestedContainer(keyedBy: AstronomyTime.CodingKeys.self, forKey: .sunrise)
                let sunriseRaw = try sunriseContainer.decode(String.self, forKey: .time)
                sunrise = AstronomyTime(dateString: dateRaw, timeString: sunriseRaw)
                
                let sunsetContainer = try container.nestedContainer(keyedBy: AstronomyTime.CodingKeys.self, forKey: .sunset)
                let sunsetRaw = try sunsetContainer.decode(String.self, forKey: .time)
                sunset = AstronomyTime(dateString: dateRaw, timeString: sunsetRaw)
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                
                let dateRaw = date.time  // Do Not Encode
                
                var sunriseContainer = container.nestedContainer(keyedBy: AstronomyTime.CodingKeys.self, forKey: .sunrise)
                let sunriseRaw = sunrise.timeString(fromBaseDate: dateRaw)
                try sunriseContainer.encode(sunriseRaw, forKey: .time)
                
                var sunsetContainer = container.nestedContainer(keyedBy: AstronomyTime.CodingKeys.self, forKey: .sunset)
                let sunsetRaw = sunset.timeString(fromBaseDate: dateRaw)
                try sunsetContainer.encode(sunsetRaw, forKey: .time)
            }
            
            public struct AstronomyTime: Codable, Equatable {
                /// 时间
                public let time: Date
                
                public enum CodingKeys: String, CodingKey {
                    case time
                }
                
                public init(dateString: String, timeString: String) {
                    time = getDatetime(fromBaseDateString: dateString, toTimeString: timeString)
                }
                
                internal func timeString(fromBaseDate date: Date) -> String {
                    return getTimeString(fromBaseDate: date, toTime: time)
                }
            }
            
        }
        // Credit: https://www.zhihu.com/question/335248021/answer/751191817
    }
    
    public struct AirQuality: Codable, Equatable {
        public typealias AQI = AverageAndExtremumWithDate<CYContent.CountryRelated<Double>>
        public typealias PM25 = AverageAndExtremumWithDate<Double>
        
        /// AQI
        public let aqi: [AQI]
        /// PM 2.5
        public let pm25: [PM25]
    }
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
    public typealias LifeIndex = CYContent.LifeIndex<[IndexWithDescriptionWithDate<String>]>
}

// MARK: - Abstract Types

extension CYDaily {
    
    public struct ValueWithDate<T: Codable & Equatable>: Codable, Equatable {
        /// 时间
        public let date: CYContent.DatetimeServerType
        /// 值
        public let value: T
    }
    
    public struct AverageAndExtremumWithDate<T: Codable & Equatable>: Codable, Equatable {
        /// 时间
        public let date: CYContent.DatetimeServerType
        /// 值
        public let value: CYContent.AverageAndExtremum<T>
        
        private enum CodingKeys: String, CodingKey {
            case date
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            date = try container.decode(CYContent.DatetimeServerType.self, forKey: .date)
            value = try CYContent.AverageAndExtremum<T>(from: decoder)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(date, forKey: .date)
            try value.encode(to: encoder)
        }
    }
    
    public struct IndexWithDescriptionWithDate<T: Codable & Equatable>: Codable, Equatable {
        /// 时间
        public let date: CYContent.DatetimeServerType
        /// 值
        public let value: CYContent.IndexWithDescription<T>
        
        private enum CodingKeys: String, CodingKey {
            case date
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            date = try container.decode(CYContent.DatetimeServerType.self, forKey: .date)
            value = try CYContent.IndexWithDescription<T>(from: decoder)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            try container.encode(date, forKey: .date)
            try value.encode(to: encoder)
        }
    }
}

// MARK: - Date shift functions

fileprivate func getDatetime(fromBaseDateString dateString: String, toTimeString timeString: String) -> Date {
    
    guard let timeStartIndex = dateString.index(dateString.startIndex, offsetBy: 11, limitedBy: dateString.endIndex), let timeEndIndex = dateString.index(dateString.startIndex, offsetBy: 16, limitedBy: dateString.endIndex) else { return Date() }
    
    let datetimeString: String = dateString.replacingCharacters(in: timeStartIndex ..< timeEndIndex, with: timeString)
    
    return DateFormatter.serverType.date(from: datetimeString) ?? Date()
}

fileprivate func getTimeString(fromBaseDate date: Date, toTime time: Date) -> String {
    
    let datetimeString = DateFormatter.serverType.string(from: time)
    
    guard let timeStartIndex = datetimeString.index(datetimeString.startIndex, offsetBy: 11, limitedBy: datetimeString.endIndex), let timeEndIndex = datetimeString.index(datetimeString.startIndex, offsetBy: 16, limitedBy: datetimeString.endIndex) else { return "00:00" }
    
    let timeStringRaw = datetimeString[timeStartIndex ..< timeEndIndex]
    
    return String(timeStringRaw)
}
