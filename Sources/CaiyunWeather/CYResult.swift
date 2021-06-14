//
//  CYResult.swift
//  
//
//  Created by 袁林 on 2021/6/13.
//

import Foundation

public struct CYResult: Codable, Equatable {
    /// 天气预警
    public let alarm: CYAlarm
    /// 实况天气信息
    public let realtime: CYRealtime
    /// 逐分钟天气预报
    //public let minutely: CYMinutely
    /// 逐小时天气预报
    //public let hourly: CYHourly
    /// 逐日天气预报
    //public let daily: CYDaily
    // let primary: Int
    /// 天气要点
    let keypoint: String
    
    private enum CodingKeys: String, CodingKey {
        case alarm = "alert"
        case realtime
        //case minutely
        //case hourly
        //case daily
        // case primary
        case keypoint = "forecast_keypoint"
    }
}
