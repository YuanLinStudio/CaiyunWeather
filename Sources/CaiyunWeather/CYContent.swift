//
//  CYContent.swift
//  
//
//  Created by 袁林 on 2021/6/13.
//

import Foundation

public struct CYContent: Codable, Equatable {
    /// 日期时间（1970 年至今的秒数）
    public struct Datetime1970Based: Codable, Equatable {
        public let time: Date
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            let timeRaw = try container.decode(Int.self)
            time = Date(timeIntervalSince1970: TimeInterval(timeRaw))
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            let timeRaw = Int(time.timeIntervalSince1970)
            try container.encode(timeRaw)
        }
    }
    /// 日期时间（服务器时间形式）
    public struct DatetimeServerType: Codable, Equatable {
        public let time: Date
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            let timeRaw = try container.decode(String.self)
            time = DateFormatter.serverType.date(from: timeRaw) ?? Date()
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            let timeRaw = DateFormatter.serverType.string(from: time)
            try container.encode(timeRaw)
        }
    }
    
    /// 生活指数
    public struct LifeIndex: Codable, Equatable {
        /// 紫外线
        public let ultraviolet: CYContent.IndexWithDescription?
        /// 舒适度
        public let comfort: CYContent.IndexWithDescription?
        /// 洗车
        public let carWashing: CYContent.IndexWithDescription?
        /// 感冒
        public let coldRisk: CYContent.IndexWithDescription?
        /// 穿衣
        public let dressing: CYContent.IndexWithDescription?
    }
    
    /// 风
    public struct Wind: Codable, Equatable {
        /// 风速
        public let speed: WindContent
        /// 风向
        public let direction: WindContent
        
        public struct WindContent: Codable, Equatable {
            /// 值
            public let value: Double
            /// 描述
            public let description: String
            
            public init(from decoder: Decoder) throws {
                let container = try decoder.singleValueContainer()
                value = try container.decode(Double.self)
                description = getDirectionDescription(value)
            }
            
            public func encode(to encoder: Encoder) throws {
                var container = encoder.singleValueContainer()
                try container.encode(value)
            }
        }
    }
    
    /// 空气质量
    public struct AirQuality: Codable, Equatable {
        /// PM 2.5
        public let pm25: Double?
        /// PM 10
        public let pm10: Double?
        /// 臭氧
        public let o3: Double?
        /// 二氧化硫
        public let so2: Double?
        /// 二氧化氮
        public let no2: Double?
        /// 一氧化碳
        public let co: Double?
        /// AQI
        public let aqi: AQI?
        /// 描述
        public let description: Description?
    }
    
    /// AQI
    public typealias AQI = CountryRelated<Int>
    /// 描述
    public typealias Description = CountryRelated<String>
    
}

// MARK: - Type of Constant Codes

extension CYContent {
    
    public enum Phenomenon: String, Codable, Equatable {
        /// 晴（白天）
        case clearDay = "CLEAR_DAY"
        /// 晴（夜间）
        case clearNight = "CLEAR_NIGHT"
        /// 多云（白天）
        case partlyCloudyDay = "PARTLY_CLOUDY_DAY"
        /// 多云（夜间）
        case partlyCloudyNight = "PARTLY_CLOUDY_NIGHT"
        /// 阴
        case cloudy = "CLOUDY"
        /// 轻度雾霾
        case lightHaze = "LIGHT_HAZE"
        /// 中度雾霾
        case moderateHaze = "MODERATE_HAZE"
        /// 重度雾霾
        case heavyHaze = "HEAVY_HAZE"
        /// 小雨
        case lightRain = "LIGHT_RAIN"
        /// 中雨
        case moderateRain = "MODERATE_RAIN"
        /// 大雨
        case heavyRain = "HEAVY_RAIN"
        /// 暴雨
        case stormRain = "STORM_RAIN"
        /// 雾
        case fog = "FOG"
        /// 小雪
        case lightSnow = "LIGHT_SNOW"
        /// 中雪
        case moderateSnow = "MODERATE_SNOW"
        /// 大雪
        case heavySnow = "HEAVY_SNOW"
        /// 暴雪
        case stormSnow = "STORM_SNOW"
        /// 浮尘
        case dust = "DUST"
        /// 沙尘
        case sand = "SAND"
        /// 大风
        case wind = "WIND"
        
        public func localized() -> String { return rawValue.localized() }
    }
    
}

// MARK: - Abstract Types

extension CYContent {
    
    public struct CountryRelated<T: Codable & Equatable>: Codable, Equatable {
        /// 国标
        public let chn: T
        /// 美标
        public let usa: T
    }
    
    public struct IndexWithDescription: Codable, Equatable {
        /// 指数
        public let index: Int
        /// 描述
        public let description: String
        
        private enum CodingKeys: String, CodingKey {
            case index
            case description = "desc"
        }
    }
    
    public struct AverageAndExtremum<T: Codable & Equatable>: Codable, Equatable {
        /// 平均值
        public let average: T
        /// 最大值
        public let maximum: T
        /// 最小值
        public let minimum: T
        
        private enum CodingKeys: String, CodingKey {
            case average = "avg"
            case maximum = "max"
            case minimum = "min"
        }
    }
}

// MARK: - Wind description of direction and speed

fileprivate func getDirectionDescription(_ direction: Double) -> String {
    var description: String
    
    switch direction {
    case 0 ..< 22.5, 337.5 ..< 360: description = "north"
    case 22.5 ..< 67.5: description = "northeast"
    case 67.5 ..< 112.5: description = "east"
    case 112.5 ..< 157.5: description = "southeast"
    case 157.5 ..< 202.5: description = "south"
    case 202.5 ..< 247.5: description = "southwest"
    case 247.5 ..< 292.5: description = "west"
    case 292.5 ..< 337.5: description = "northwest"
    default: description = "N/A"
    }
    return description.localized()
}

fileprivate func getSpeedDescription(_ speed: Double) -> String {
    var description: String
    switch speed.rounded() {
    case 0 ..< 1: description = "level-0"
    case 1 ..< 6: description = "level-1"
    case 6 ..< 12: description = "level-2"
    case 12 ..< 20: description = "level-3"
    case 20 ..< 29: description = "level-4"
    case 29 ..< 39: description = "level-5"
    case 39 ..< 50: description = "level-6"
    case 50 ..< 62: description = "level-7"
    case 62 ..< 75: description = "level-8"
    case 75 ..< 89: description = "level-9"
    case 89 ..< 103: description = "level-10"
    case 103 ..< 117: description = "level-11"
    case 117 ..< 134: description = "level-12"
    default: description = "N/A"
    }
    return description.localized()
}
