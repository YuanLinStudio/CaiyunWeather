//
//  Extensions.swift
//  
//
//  Created by 袁林 on 2021/6/13.
//

import Foundation

extension String {
    
    func localized(comment: String? = nil) -> String {
        return NSLocalizedString(self, comment: comment ?? "")
    }
}
