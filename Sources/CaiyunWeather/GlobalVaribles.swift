//
//  File.swift
//  
//
//  Created by 袁林 on 2021/6/14.
//

import Foundation

internal var unit: CYUnit = .metric

public enum CYUnit: String, Codable, Equatable {
    /// 默认公制
    case metric
    /// 英制
    case imperial
    /// 科学单位制
    case si
    /// 公制 v1
    case metricV1 = "metric:v1"
    /// 公制 v2
    case metricV2 = "metric:v2"
    
    var system: CYUnitSystem { return unitSystems[self]! }
}

internal struct CYUnitSystem: Codable, Equatable {
    let realtimePrecipitation: SpeedUnit
    let minutelyPrecipitation: SpeedUnit
    let hourlyPrecipitation: SpeedUnit
    let dailyPrecipitation: SpeedUnit
    let distance: DistanceUnit
    let temperature: TemperatureUnit
    let pressure: PressureUnit
    let humidity: RatioUnit
    let windDirection: DirectionUnit
    let windSpeed: SpeedUnit
    let cloudrate: RatioUnit
    let visibility: DistanceUnit
    
    enum SpeedUnit: String, Codable, Equatable {
        case meterPerSecond = "m/s"
        case inchPerHour = "in/hr"
        case ratio = ""
        case millimeterPerHour = "mm/hr"
        case milePerHour = "mph"
        case kilometerPerHour = "km/h"
    }
    enum DistanceUnit: String, Codable, Equatable {
        case meter = "m"
        case mile = "mi"
        case kilometer = "km"
    }
    enum TemperatureUnit: String, Codable, Equatable {
        case kelvin = "K"
        case fahrenheit = "˚F"
        case celsius = "˚C"
    }
    enum PressureUnit: String, Codable, Equatable {
        case pascal = "Pa"
    }
    enum RatioUnit: String, Codable, Equatable {
        case ratio = ""
    }
    enum DirectionUnit: String, Codable, Equatable {
        case degree = "˚"
    }
}

extension CYUnitSystem {
    static let metric = CYUnitSystem(realtimePrecipitation: .ratio, minutelyPrecipitation: .ratio, hourlyPrecipitation: .millimeterPerHour, dailyPrecipitation: .millimeterPerHour, distance: .kilometer, temperature: .celsius, pressure: .pascal, humidity: .ratio, windDirection: .degree, windSpeed: .kilometerPerHour, cloudrate: .ratio, visibility: .kilometer)
    static let imperial = CYUnitSystem(realtimePrecipitation: .inchPerHour, minutelyPrecipitation: .inchPerHour, hourlyPrecipitation: .inchPerHour, dailyPrecipitation: .inchPerHour, distance: .mile, temperature: .fahrenheit, pressure: .pascal, humidity: .ratio, windDirection: .degree, windSpeed: .milePerHour, cloudrate: .ratio, visibility: .mile)
    static let si = CYUnitSystem(realtimePrecipitation: .meterPerSecond, minutelyPrecipitation: .meterPerSecond, hourlyPrecipitation: .meterPerSecond, dailyPrecipitation: .meterPerSecond, distance: .meter, temperature: .kelvin, pressure: .pascal, humidity: .ratio, windDirection: .degree, windSpeed: .meterPerSecond, cloudrate: .ratio, visibility: .meter)
    static let metricV1 = CYUnitSystem(realtimePrecipitation: .ratio, minutelyPrecipitation: .ratio, hourlyPrecipitation: .ratio, dailyPrecipitation: .ratio, distance: .kilometer, temperature: .celsius, pressure: .pascal, humidity: .ratio, windDirection: .degree, windSpeed: .kilometerPerHour, cloudrate: .ratio, visibility: .kilometer)
    static let metricV2 = CYUnitSystem(realtimePrecipitation: .millimeterPerHour, minutelyPrecipitation: .millimeterPerHour, hourlyPrecipitation: .millimeterPerHour, dailyPrecipitation: .millimeterPerHour, distance: .kilometer, temperature: .celsius, pressure: .pascal, humidity: .ratio, windDirection: .degree, windSpeed: .kilometerPerHour, cloudrate: .ratio, visibility: .kilometer)
}

fileprivate let unitSystems: [CYUnit: CYUnitSystem] = [
    .metric: .metric,
    .imperial: .imperial,
    .si: .si,
    .metricV1: .metricV1,
    .metricV2: .metricV2
]
