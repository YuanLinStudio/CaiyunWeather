//
//  CYEndpoint.swift
//  
//
//  Created by 袁林 on 2021/6/12.
//

import Foundation

/// `CYEndpoint` defines all information about API requests, including token, version, target files, etc.·
public struct CYEndpoint: Codable, Equatable {
    /// Token
    public var token: String! = nil
    /// 坐标
    public var coordinate: CYCoordinate = .defaultCoordinate
    
    /// 请求语言
    public var language: RequestLanguage = .chineseSimplified
    /// 单位制
    public var measurementSystem: MeasurementSystem {
        get { return unit }
        set { unit = newValue }
    }
    /// 请求文件类型。仅支持 weather.json 文件，不建议修改
    public var file: String = "weather.json"
    /// API 版本
    public var version: String = "v2.5"
    /// 是否包含预警信息
    public var shouldIncludeWarnings: Bool = true
    /// 逐小时天气预报长度，范围 1～360
    public var hourlyLength: Int = 48
    /// 逐日天气预报长度，范围 1～15
    public var dailyLength: Int = 5
    
    /// 根据 `CYEndpoint` 设置获得的 `URLComponents` 对象
    var components: URLComponents { return getComponents() }
    
    /// 根据 `CYEndpoint` 设置得到的请求 URL
    public var url: URL! { return components.url }
}

extension CYEndpoint {
    
    public init(token: String? = nil, coordinate: CYCoordinate = .defaultCoordinate) {
        self.token = token
        self.coordinate = coordinate
    }
    
    func getComponents() -> URLComponents {
        // Credit: https://www.swiftbysundell.com/articles/constructing-urls-in-swift/
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.caiyunapp.com"
        components.path = ["", version, token, coordinate.urlString, file].joined(separator: "/")
        components.queryItems = [
            URLQueryItem(name: "alert", value: "\(shouldIncludeWarnings)"),
            URLQueryItem(name: "lang", value: language.rawValue),
            URLQueryItem(name: "unit", value: measurementSystem.rawValue),
            URLQueryItem(name: "dailysteps", value: "\(dailyLength)"),
            URLQueryItem(name: "hourlysteps", value: "\(hourlyLength)"),
        ]
        return components
    }
    
    public typealias MeasurementSystem = CYUnit
    
    public enum RequestLanguage: String, Codable, Equatable {
        case chineseSimplified = "zh_CN"
        case chineseTraditional = "zh_TW"
        case englishUS = "en_US"
        case englishUK = "en_UK"
        case japanese = "jp"
    }
}
