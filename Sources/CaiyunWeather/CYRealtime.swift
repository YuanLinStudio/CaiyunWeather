//
//  CYRealtime.swift
//  
//
//  Created by 袁林 on 2021/6/13.
//

import Foundation

public struct CYRealtime: Codable, Equatable {
    /// 响应状态
    public let responseStatus: String
    /// 温度
    public let temperature: Double
    /// 体感温度
    public let apparentTemperature: Double
    /// 气压
    public let pressure: Double
    /// 湿度
    public let humidity: Double
    /// 云量
    public let cloudrate: Double
    /// 能见度
    public let visibility: Double
    /// Downward Short-Wave Radiation Flux, 向下短波辐射通量 (W/M2)
    public let dswrf: Double
    
    /// 主要天气现象
    public let phenomenon: CYContent.Phenomenon
    /// 风向风力
    public let wind: CYContent.Wind
    /// 降水量
    public let precipitation: Precipitation
    /// 空气质量
    public let airQuality: CYContent.AirQuality?
    /// 生活指数
    public let lifeIndex: CYContent.LifeIndex<CYContent.IndexWithDescription<Int>>
    
    private enum CodingKeys: String, CodingKey {
        case responseStatus = "status"
        case temperature
        case apparentTemperature = "apparent_temperature"
        case pressure
        case humidity
        case cloudrate
        case phenomenon = "skycon"
        case visibility
        case dswrf
        case wind
        case precipitation
        case airQuality = "air_quality"
        case lifeIndex = "life_index"
    }
}

// MARK: - Redefined Types

extension CYRealtime {
    /// 降水量
    public struct Precipitation: Codable, Equatable {
        /// 本地
        public let local: PrecipitationContent
        /// 附近
        public let nearest: PrecipitationContent?
        
        public struct PrecipitationContent: Codable, Equatable {
            /// 响应状态
            public let responseStatus: String
            /// 数据源
            public let datasource: String?
            /// 降水强度
            public let intensity: Double
            /// 距离
            public let distance: Double?
            
            private enum CodingKeys: String, CodingKey {
                case responseStatus = "status"
                case datasource
                case intensity
                case distance
            }
        }
    }
}
