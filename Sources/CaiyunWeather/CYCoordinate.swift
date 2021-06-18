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

/*
/// Use `CYCoordinate` to deal with CY API requests.
public struct CYCoordinate1: Codable, Equatable {
    public typealias CYCoordinateDegrees = Double
    /// 经度
    let longitude: CYCoordinateDegrees
    /// 纬度
    let latitude: CYCoordinateDegrees
    // /// 高度
    // let elevation: Double
    
    /// 默认坐标位置（经纬度均为 0）
    public static let defaultCoordinate = CYCoordinate1(longitude: .zero, latitude: .zero)
    
    public init(longitude: CYCoordinateDegrees, latitude: CYCoordinateDegrees) {
        self.longitude = longitude
        self.latitude = latitude
    }
    
    public init(latitude: CYCoordinateDegrees, longitude: CYCoordinateDegrees) {
        self.init(longitude: longitude, latitude: latitude)
    }
}

// MARK: - Work with Core Location

extension CYCoordinate1 {
    public init(_ coordinate: CLLocationCoordinate2D) {
        self.init(longitude: coordinate.longitude, latitude: coordinate.latitude)
    }
    
    /// To `CLLocationCoordinate2D` objects.
    public var clLocationCoordinate2D: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
}

// MARK: - Work with CYResponse Codable

extension CYCoordinate1 {
    /// String used in API request.
    var urlString: String { return String(format: "%.4f,%.4f", longitude, latitude) }
    
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
*/
