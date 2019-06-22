//
//  Validator.swift
//  SimpleEquation
//
//  Created by Przemysław Kalawski on 22/06/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import Foundation

class Validator {
    
    private static let digits: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    private static let weakFunctions: [String] = ["+", "-"]
    private static let strongFunctions: [String] = ["/", "*"]
    private static let parenthesis: [String] = ["(", ")"]
    
    public static func isValid(expression: String) throws -> Bool {
        return try checkParenthesis(expression: expression) && (try checkLetters(expression: expression))
    }
    
    private static func checkParenthesis(expression: String) throws -> Bool {
        var left = 0
        var right = 0
        var index = 0
        let expArray = Array(expression)
        
        while left >= right && index < expArray.count {
            if expArray[index] == "(" {
                left += 1
            }
            else if expArray[index] == ")" {
                right += 1
            }
            index += 1
        }
        
        if left != right {
            throw OperationError.invalidParenthesis
        }
        
        return true
    }
    
    private static func checkLetters(expression: String) throws -> Bool {
        let expArray = Array(expression)
        for item in expArray {
            let itemString = String(item)
            if !digits.contains(itemString) && !weakFunctions.contains(itemString) && !strongFunctions.contains(itemString) && !parenthesis.contains(itemString) {
                throw OperationError.unauthorizeLetter
            }
        }
        
        return true
    }
}
