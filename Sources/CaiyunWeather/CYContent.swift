//
//  CYContent.swift
//  
//
//  Created by 袁林 on 2021/6/13.
//

import Foundation


public struct CYContent: Codable {
    
    public typealias API = CountryRelated<Int>
    public typealias Description = CountryRelated<String>
    
    public struct LifeIndex: Codable {
        public let ultraviolet: CYContent.IndexWithDescription
        public let comfort: CYContent.IndexWithDescription
    }
    
    public struct Wind: Codable {
        public let speed: Double
        public let direction: Double
    }
    
    public struct AirQuality: Codable {
        public let pm25: Double
        public let pm10: Double
        public let o3: Double
        public let so2: Double
        public let no2: Double
        public let co: Double
        public let aqi: API
        public let description: Description
    }
    
    public struct Precipitation: Codable {
        public let local: LocalPrecipitation
        public let nearest: NearestPrecipitation?
        
        public struct LocalPrecipitation: Codable {
            public let responseStatus: String
            public let datasource: String
            public let intensity: Double
            
            private enum CodingKeys: String, CodingKey {
                case responseStatus = "status"
                case datasource
                case intensity
            }
        }
        
        public struct NearestPrecipitation: Codable {
            public let responseStatus: String
            public let intensity: Double
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
    
    public enum Phenomenon: String, Codable {
        case clearDay = "CLEAR_DAY"
        case clearNight = "CLEAR_NIGHT"
        case partlyCloudyDay = "PARTLY_CLOUDY_DAY"
        case partlyCloudyNight = "PARTLY_CLOUDY_NIGHT"
        case cloudy = "CLOUDY"
        case lightHaze = "LIGHT_HAZE"
        case moderateHaze = "MODERATE_HAZE"
        case heavyHaze = "HEAVY_HAZE"
        case lightRain = "LIGHT_RAIN"
        case moderateRain = "MODERATE_RAIN"
        case heavyRain = "HEAVY_RAIN"
        case stormRain = "STORM_RAIN"
        case fog = "FOG"
        case lightSnow = "LIGHT_SNOW"
        case moderateSnow = "MODERATE_SNOW"
        case heavySnow = "HEAVY_SNOW"
        case stormSnow = "STORM_SNOW"
        case dust = "DUST"
        case sand = "SAND"
        case wind = "WIND"
        
        public func localized() -> String { return rawValue.localized() }
    }
    
}


// MARK: - Generic Types

extension CYContent {
    
    public struct CountryRelated<T: Codable>: Codable {
        public let chn: T
        public let usa: T
    }
    
    public struct IndexWithDescription: Codable {
        public let index: Int
        public let description: String
        
        private enum CodingKeys: String, CodingKey {
            case index
            case description = "desc"
        }
    }
}
