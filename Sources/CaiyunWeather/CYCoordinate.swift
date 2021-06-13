//
//  CYCoordinate.swift
//  
//
//  Created by 袁林 on 2021/6/12.
//

import Foundation
import CoreLocation

/// Use `CYCoordinate` to deal with CY API requests.
public struct CYCoordinate: Codable, Equatable {
    typealias CYCoordinateDegrees = Double
    /// 经度
    let longitude: CYCoordinateDegrees
    /// 纬度
    let latitude: CYCoordinateDegrees
    // /// 高度
    // let elevation: Double
    
    public static let defaultCoordinate = CYCoordinate(longitude: .zero, latitude: .zero)
}

// MARK: - Work with Core Location

extension CYCoordinate {
    public init(_ coordinate: CLLocationCoordinate2D) {
        self.init(longitude: coordinate.longitude, latitude: coordinate.latitude)
    }
    
    /// To `CLLocationCoordinate2D` objects.
    public var clLocationCoordinate2D: CLLocationCoordinate2D { return CLLocationCoordinate2D(latitude: latitude, longitude: longitude) }
}

// MARK: - Work with CYResponse Codable

extension CYCoordinate {
    /// String used in API request.
    var urlString: String { return String(format: "%.4f,%.4f", longitude, latitude) }
    
    init(fromArray array: [Double]) {
        self.init(longitude: array[0], latitude: array[1])
    }
    
    var array: [Double] { return [longitude, latitude] }
}
