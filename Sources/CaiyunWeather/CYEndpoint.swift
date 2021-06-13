//
//  CYEndpoint.swift
//  
//
//  Created by 袁林 on 2021/6/12.
//

import Foundation

struct CYEndpoint: Codable, Equatable {
    let token: String
    var coordinate: CYCoordinate = .defaultCoordinate
    
    var language: String = "zh_CN"
    var measurementSystem: MeasurementSystem = .metric
    
    var file: String = "weather.json"
    var version: String = "v2.5"
    
    var components: URLComponents { return getComponents() }
    var url: URL! { return components.url }
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
    
    enum MeasurementSystem: String, Codable {
        case metric
        case imperial
    }
}
