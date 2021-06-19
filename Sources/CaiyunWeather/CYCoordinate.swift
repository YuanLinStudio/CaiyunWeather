//
//  CYCoordinate.swift
//  
//
//  Created by 袁林 on 2021/6/12.
//

import Foundation
import CoreLocation

public typealias CYCoordinate = CLLocationCoordinate2D

extension CYCoordinate {
    public init(longitude: Double, latitude: Double) {
        self.init(latitude: latitude, longitude: longitude)
    }
    
    /// String used in API request.
    var urlString: String { return String(format: "%.4f,%.4f", longitude, latitude) }
    
    /// 默认坐标位置（经纬度均为 0）
    public static let defaultCoordinate = CYCoordinate(longitude: .zero, latitude: .zero)
}

extension CYCoordinate: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        let coordinateRaw = try container.decode([Double].self)
        self.init(latitude: coordinateRaw[0], longitude: coordinateRaw[1])
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        try container.encode([latitude, longitude])
    }
}

extension CYCoordinate: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
