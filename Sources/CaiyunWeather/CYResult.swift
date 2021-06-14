//
//  CYResult.swift
//  
//
//  Created by 袁林 on 2021/6/13.
//

import Foundation

public struct CYResult: Codable {
    
    //public let alarm: CYAlarm
    //public let realtime: CYRealtime
    //public let minutely: CYMinutely
    //public let hourly: CYHourly
    //public let daily: CYDaily
    // let primary: Int
    let keypoint: String
    
    private enum CodingKeys: String, CodingKey {
        //case alarm = "alert"
        //case realtime
        //case minutely
        //case hourly
        //case daily
        // case primary
        case keypoint = "forecast_keypoint"
    }
}
