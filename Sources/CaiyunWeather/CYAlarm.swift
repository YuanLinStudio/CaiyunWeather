//
//  CYAlarm.swift
//  
//
//  Created by 袁林 on 2021/6/14.
//

import Foundation

public struct CYAlarm: Codable, Equatable {
    /// 响应状态
    public let responseStatus: String
    /// 内容
    public let content: [AlarmContent]
    
    private enum CodingKeys: String, CodingKey {
        case responseStatus = "status"
        case content
    }
}

extension CYAlarm {
    
    public struct AlarmContent: Codable, Equatable {
        /// 发布时间
        public let publishTime: CYContent.Datetime1970Based
        /// 预警 ID
        public let id: String
        /// 预警信息的状态
        public let status: String
        /// 区域代码
        public let adcode: String
        /// 位置
        public let location: String
        /// 省
        public let province: String
        /// 市
        public let city: String
        /// 县
        public let county: String
        /// 预警代码
        public let code: AlarmCode
        /// 发布单位
        public let source: String
        /// 标题
        public let title: String
        /// 描述
        public let description: String
        
        private enum CodingKeys: String, CodingKey {
            case publishTime = "pubtimestamp"
            case id = "alertId"
            case status
            case adcode
            case location
            case province
            case city
            case county
            case code
            case source
            case title
            case description
        }
    }
}

// MARK: - Redefined Types

extension CYAlarm.AlarmContent {
    
    public struct AlarmCode: Equatable, Codable {
        /// 预警类型
        public let type: AlarmType
        /// 预警级别
        public let level: AlarmLevel
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            let code = try container.decode(String.self)
            
            let typeCode = String(code.prefix(2))
            self.type = AlarmType(rawValue: typeCode)!
            
            let levelCode = String(code.suffix(2))
            self.level = AlarmLevel(rawValue: levelCode)!
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            let code: String = "\(type.rawValue)\(level.rawValue)"
            try container.encode(code)
        }
    }
}

// MARK: - Lookups

extension CYAlarm.AlarmContent.AlarmCode {
    
    public enum AlarmType: String, Equatable {
        /// 台风
        case typhoon = "01"
        /// 暴雨
        case rainstorm = "02"
        /// 暴雪
        case snowstorm = "03"
        /// 寒潮
        case coldWave = "04"
        /// 大风
        case gale = "05"
        /// 沙尘暴
        case sandstorm = "06"
        /// 高温
        case heatWave = "07"
        /// 干旱
        case drought = "08"
        /// 雷电
        case lightning = "09"
        /// 冰雹
        case hail = "10"
        /// 霜冻
        case frost = "11"
        /// 大雾
        case heavyFog = "12"
        /// 霾
        case haze = "13"
        /// 道路结冰
        case roadIcing = "14"
        /// 森林火险
        case wildFire = "15"
        /// 雷雨大风
        case thunderGust = "16"
        
        public var description: String { return alarmTypeDescriptions[self]! }
    }
    
    public enum AlarmLevel: String, Equatable {
        /// 蓝色
        case blue = "01"
        /// 黄色
        case yellow = "02"
        /// 橙色
        case orange = "03"
        /// 红色
        case red = "04"
        
        public var description: String { return alarmLevelDescriptions[self]! }
    }
}

fileprivate let alarmTypeDescriptions: [CYAlarm.AlarmContent.AlarmCode.AlarmType: String] = [
    .typhoon: "typhoon",
    .rainstorm: "rainstorm",
    .snowstorm: "snowstorm",
    .coldWave: "cold-wave",
    .gale: "gale",
    .sandstorm: "sandstorm",
    .heatWave: "heat-wave",
    .drought: "drought",
    .lightning: "lightning",
    .hail: "hail",
    .frost: "frost",
    .heavyFog: "heavy-fog",
    .haze: "haze",
    .roadIcing: "road-icing",
    .wildFire: "wild-fire",
    .thunderGust: "thunder-gust",
]

fileprivate let alarmLevelDescriptions: [CYAlarm.AlarmContent.AlarmCode.AlarmLevel: String] = [
    .blue: "blue",
    .yellow: "yellow",
    .orange: "orange",
    .red: "red",
]
