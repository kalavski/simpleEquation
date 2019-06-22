//
//  OperationError.swift
//  SimpleEquation
//
//  Created by Przemysław Kalawski on 19/06/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import Foundation


enum OperationError: Error {
    case zeroDivisior
    case unauthorized
    case invalidParenthesis
}

extension OperationError: LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .zeroDivisior:
            return "Division by zero is not possible!"
        case .unauthorized:
            return "Operation is unauthorized!"
        case .invalidParenthesis:
            return "Invalid number of parentheses!"
        }
    }
}
