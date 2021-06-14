//
//  CYContent.swift
//  
//
//  Created by 袁林 on 2021/6/13.
//

import Foundation

public struct CYContent: Codable, Equatable {
    
    /// 生活指数
    public struct LifeIndex: Codable, Equatable {
        /// 紫外线
        public let ultraviolet: CYContent.IndexWithDescription
        /// 舒适度
        public let comfort: CYContent.IndexWithDescription
    }
    
    /// 风
    public struct Wind: Codable, Equatable {
        /// 风速
        public let speed: Double
        /// 风向
        public let direction: Double
    }
    
    /// 空气质量
    public struct AirQuality: Codable, Equatable {
        /// PM 2.5
        public let pm25: Double
        /// PM 10
        public let pm10: Double
        /// 臭氧
        public let o3: Double
        /// 二氧化硫
        public let so2: Double
        /// 二氧化氮
        public let no2: Double
        /// 一氧化碳
        public let co: Double
        /// AQI
        public let aqi: AQI
        /// 描述
        public let description: Description
    }
    
    /// AQI
    public typealias AQI = CountryRelated<Int>
    /// 描述
    public typealias Description = CountryRelated<String>
    
    /// 降水量
    public struct Precipitation: Codable, Equatable {
        /// 本地
        public let local: LocalPrecipitation
        /// 附近
        public let nearest: NearestPrecipitation?
        
        public struct LocalPrecipitation: Codable, Equatable {
            /// 响应状态
            public let responseStatus: String
            /// 数据源
            public let datasource: String
            /// 降水强度
            public let intensity: Double
            
            private enum CodingKeys: String, CodingKey {
                case responseStatus = "status"
                case datasource
                case intensity
            }
        }
        
        public struct NearestPrecipitation: Codable, Equatable {
            /// 响应状态
            public let responseStatus: String
            /// 降水强度
            public let intensity: Double
            /// 距离
            public let distance: Double
            
            private enum CodingKeys: String, CodingKey {
                case responseStatus = "status"
                case intensity
                case distance
            }
        }
    }
    
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


// MARK: - Generic Types

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
    
    public struct ValueWithDatetime<T: Codable & Equatable>: Codable, Equatable {
        /// 时间
        public let datetime: Date
        /// 值
        public let value: T
        
        private enum CodingKeys: String, CodingKey {
            case datetime
            case value
        }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            let datetimeRaw = try container.decode(String.self, forKey: .datetime)
            datetime = DateFormatter.serverType.date(from: datetimeRaw) ?? Date()
            
            value = try container.decode(T.self, forKey: .value)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            
            let datetimeRaw = DateFormatter.serverType.string(from: datetime)
            try container.encode(datetimeRaw, forKey: .datetime)
            
            try container.encode(value, forKey: .value)
        }
    }
}
