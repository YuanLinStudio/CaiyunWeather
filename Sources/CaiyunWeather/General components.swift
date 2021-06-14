//
//  File.swift
//  
//
//  Created by 袁林 on 2021/6/13.
//

import Foundation

public struct LifeIndex: Codable {
    
    let ultraviolet: LifeIndexContent
    let comfort: LifeIndexContent
    
    struct LifeIndexContent: Codable {
        
        let index: Int
        let description: String
        
        enum CodingKeys: String, CodingKey {
            case index
            case description = "desc"
        }
    }
}


public struct CYWind: Codable {
    
    let speed: Double
    let direction: Double
}
