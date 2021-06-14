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
