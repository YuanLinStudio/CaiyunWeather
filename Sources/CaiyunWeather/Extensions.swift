//
//  Extensions.swift
//  
//
//  Created by 袁林 on 2021/6/13.
//

import Foundation

extension String {
    public func localized(comment: String? = nil) -> String {
        return NSLocalizedString(self, bundle: Bundle.module, comment: comment ?? "")
    }
}

extension DateFormatter {
    static let serverType: DateFormatter = {
        // Credit: https://stackoverflow.com/questions/35700281/date-format-in-swift
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mmZZZZZ"
        return formatter
    }()
}

// Credit: https://stackoverflow.com/a/59292570/14640876

extension Range where Bound: AdditiveArithmetic & ExpressibleByIntegerLiteral {
    init(center: Bound, tolerance: Bound) {
        self.init(uncheckedBounds: (lower: center - tolerance, upper: center + tolerance))
    }
}

extension ClosedRange where Bound: AdditiveArithmetic {
    init(center: Bound, tolerance: Bound) {
        self.init(uncheckedBounds: (lower: center - tolerance, upper: center + tolerance))
    }
}

// Credit: https://stackoverflow.com/a/35407213/14640876

extension String {
    func convertToTimeInterval() -> TimeInterval {
        guard self != "" else { return 0 }
        
        var interval: Double = 0
        
        let parts = self.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(60, Double(index + 1))
        }
        return interval
    }
}

// Credit: https://stackoverflow.com/a/28872601/14640876

extension TimeInterval {
    func convertToString() -> String {
        
        let time = Int(self.rounded(.towardZero))

        // let milliseconds = Int((self.truncatingRemainder(dividingBy: 1)) * 1000)
        // let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)

        // return String(format: "%0.2d:%0.2d:%0.2d.%0.3d", hours, minutes, seconds, milliseconds)
        return String(format: "%0.2d:%0.2d", hours, minutes)
    }
}
