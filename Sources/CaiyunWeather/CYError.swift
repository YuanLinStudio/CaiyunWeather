//
//  CYError.swift
//  
//
//  Created by 袁林 on 2021/6/12.
//

import Foundation

public enum CYError: Error, Equatable {
    case tokenIsNil
    case fileDontExist
    case invalidResponse(description: String)
}
