//
//  CYUnit.swift
//  
//
//  Created by 袁林 on 2021/6/14.
//

import Foundation

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
    
    public var system: UnitSystem { return unitSystems[self]! }
}

// MARK: - Unit system for requested unit sets

extension CYUnit {
    public struct UnitSystem: Equatable {
        public let realtimePrecipitation: UnitSpeed
        public let minutelyPrecipitation: UnitSpeed
        public let hourlyPrecipitation: UnitSpeed
        public let dailyPrecipitation: UnitSpeed
        public let distance: UnitLength
        public let temperature: UnitTemperature
        public let pressure: UnitPressure
        public let humidity: UnitRatio
        public let windDirection: UnitAngle
        public let windSpeed: UnitSpeed
        public let cloudrate: UnitRatio
        public let visibility: UnitLength
    }
}

extension CYUnit.UnitSystem {
    static let metric = CYUnit.UnitSystem(realtimePrecipitation: .intensityRatio, minutelyPrecipitation: .intensityRatio, hourlyPrecipitation: .millimetersPerHour, dailyPrecipitation: .millimetersPerHour, distance: .kilometers, temperature: .celsius, pressure: .pascal, humidity: .ratio, windDirection: .degrees, windSpeed: .kilometersPerHour, cloudrate: .ratio, visibility: .kilometers)
    static let imperial = CYUnit.UnitSystem(realtimePrecipitation: .inchesPerHour, minutelyPrecipitation: .inchesPerHour, hourlyPrecipitation: .inchesPerHour, dailyPrecipitation: .inchesPerHour, distance: .miles, temperature: .fahrenheit, pressure: .pascal, humidity: .ratio, windDirection: .degrees, windSpeed: .milesPerHour, cloudrate: .ratio, visibility: .miles)
    static let si = CYUnit.UnitSystem(realtimePrecipitation: .metersPerSecond, minutelyPrecipitation: .metersPerSecond, hourlyPrecipitation: .metersPerSecond, dailyPrecipitation: .metersPerSecond, distance: .meters, temperature: .kelvin, pressure: .pascal, humidity: .ratio, windDirection: .degrees, windSpeed: .metersPerSecond, cloudrate: .ratio, visibility: .meters)
    static let metricV1 = CYUnit.UnitSystem(realtimePrecipitation: .intensityRatio, minutelyPrecipitation: .intensityRatio, hourlyPrecipitation: .intensityRatio, dailyPrecipitation: .intensityRatio, distance: .kilometers, temperature: .celsius, pressure: .pascal, humidity: .ratio, windDirection: .degrees, windSpeed: .kilometersPerHour, cloudrate: .ratio, visibility: .kilometers)
    static let metricV2 = CYUnit.UnitSystem(realtimePrecipitation: .millimetersPerHour, minutelyPrecipitation: .millimetersPerHour, hourlyPrecipitation: .millimetersPerHour, dailyPrecipitation: .millimetersPerHour, distance: .kilometers, temperature: .celsius, pressure: .pascal, humidity: .ratio, windDirection: .degrees, windSpeed: .kilometersPerHour, cloudrate: .ratio, visibility: .kilometers)
}

fileprivate let unitSystems: [CYUnit: CYUnit.UnitSystem] = [
    .metric: .metric,
    .imperial: .imperial,
    .si: .si,
    .metricV1: .metricV1,
    .metricV2: .metricV2
]

// MARK: - Foundation.Dimension extensions

public class UnitRatio: Dimension {
    static let ratio = UnitRatio(symbol: "", converter: UnitConverterLinear(coefficient: 1.0))
    static let baseUnit = UnitRatio.ratio
}

extension UnitSpeed {
    static let inchesPerHour = UnitSpeed(symbol: "in/hr", converter: UnitConverterLinear(coefficient: 0.0254 / 3600))
    static let millimetersPerHour = UnitSpeed(symbol: "mm/h", converter: UnitConverterLinear(coefficient: 0.001 / 3600))
    static let intensityRatio = UnitSpeed(symbol: "", converter: IntensityRatioUnitConverter())
}

extension UnitPressure {
    static let pascal = UnitPressure(symbol: "Pa", converter: UnitConverterLinear(coefficient: 1.0))
}

/// 雷达降水强度到降水量的转换
/// 参考：https://open.caiyunapp.com/%E5%BD%A9%E4%BA%91%E5%A4%A9%E6%B0%94_API_%E4%B8%80%E8%A7%88%E8%A1%A8
/// 拟合公式：mm/h = 0.0637 * exp( 14.481 * ratio )
/// 拟合精度：0.9958
fileprivate class IntensityRatioUnitConverter: UnitConverter {
    override func baseUnitValue(fromValue value: Double) -> Double {
        let valueInMillimetersPerHour = 0.0637 * exp(14.481 * value)
        let baseUnitValue = Measurement(value: valueInMillimetersPerHour, unit: UnitSpeed.millimetersPerHour).converted(to: .metersPerSecond).value
        return baseUnitValue
    }
    override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
        let valueInMillimetersPerHour = Measurement(value: baseUnitValue, unit: UnitSpeed.metersPerSecond).converted(to: .millimetersPerHour).value
        let value = log(valueInMillimetersPerHour / 0.0637) / 14.481
        return value
    }
}
