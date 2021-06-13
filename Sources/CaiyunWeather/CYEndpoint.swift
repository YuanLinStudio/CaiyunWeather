//
//  CYEndpoint.swift
//  
//
//  Created by 袁林 on 2021/6/12.
//

import Foundation

public struct CYEndpoint: Codable, Equatable {
    let token: String
    public var coordinate: CYCoordinate = .defaultCoordinate
    
    public var language: String = "zh_CN"
    public var measurementSystem: MeasurementSystem = .metric
    
    public var file: String = "weather.json"
    public var version: String = "v2.5"
    
    public var components: URLComponents { return getComponents() }
    public var url: URL! { return components.url }
}

extension CYEndpoint {
    
    func getComponents() -> URLComponents {
        // Credit: https://www.swiftbysundell.com/articles/constructing-urls-in-swift/
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.caiyunapp.com"
        components.path = ["", version, token, coordinate.urlString, file].joined(separator: "/")
        components.queryItems = [
            URLQueryItem(name: "alert", value: "true"),
            URLQueryItem(name: "lang", value: language),
            URLQueryItem(name: "unit", value: measurementSystem.rawValue),
        ]
        return components
    }
    
    public enum MeasurementSystem: String, Codable {
        case metric
        case imperial
    }
}
