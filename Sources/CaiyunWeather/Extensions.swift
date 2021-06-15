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
