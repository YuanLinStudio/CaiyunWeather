//
//  CYMinutely.swift
//  
//
//  Created by 袁林 on 2021/6/14.
//

import Foundation

public struct CYMinutely: Codable, Equatable {
    /// 数据源
    public let datasource: String
    /// 描述
    public let description: String
    /// 降水概率
    public let probability: [Double]
    /// 降水强度
    public let intensity: [Double]
    
    private enum CodingKeys: String, CodingKey {
        case datasource
        case description
        case probability
        case intensity = "precipitation_2h"
    }
}
