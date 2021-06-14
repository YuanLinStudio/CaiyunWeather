//
//  CYRealtime.swift
//  
//
//  Created by 袁林 on 2021/6/13.
//

import Foundation

public struct CYRealtime: Codable {
    
    let responseStatus: String
    let temperature: Double
    let apparentTemperature: Double
    let pressure: Double
    let humidity: Double
    let cloudrate: Double
    let phenomenon: String
    let visibility: Double
    let dswrf: Double  // Downward Short-Wave Radiation Flux, 向下短波辐射通量 (W/M2)
    
    let wind: CYWind
    let precipitation: Precipitation
    let airQuality: AirQuality?
    let lifeIndex: LifeIndex
    
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

extension CYRealtime {
    
    struct Precipitation: Codable {
        
        let local: LocalPrecipitation
        let nearest: NearestPrecipitation?
        
        struct LocalPrecipitation: Codable {
            
            let responseStatus: String
            let datasource: String
            let intensity: Double
            
            enum CodingKeys: String, CodingKey {
                case responseStatus = "status"
                case datasource
                case intensity
            }
        }
        
        struct NearestPrecipitation: Codable {
            
            let responseStatus: String
            let intensity: Double
            let distance: Double
            
            enum CodingKeys: String, CodingKey {
                case responseStatus = "status"
                case intensity
                case distance
            }
        }
    }
    
    struct AirQuality: Codable {
        let pm25: Double
        let pm10: Double
        let o3: Double
        let so2: Double
        let no2: Double
        let co: Double
        let aqi: AQI
        let description: Description
        
        struct AQI: Codable {
            let chn: Int
            let usa: Int
        }
        
        struct Description: Codable {
            let chn: String
            let usa: String
        }
    }
}
