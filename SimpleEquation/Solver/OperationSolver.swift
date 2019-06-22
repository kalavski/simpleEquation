//
//  OperationSolver.swift
//  SimpleEquation
//
//  Created by Przemysław Kalawski on 19/06/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import Foundation

protocol OperationDelegate: class {
    func solvedExpression(_ score: Double, _ error: Error?)
}

final class OperationSolver {
    
    weak var delegate: OperationDelegate?
    
    private static let digits: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    private static let weakFunctions: [String] = ["+", "-"]
    private static let strongFunctions: [String] = ["/", "*"]
    
    private let operationQueue = OperationQueue()
    
    public func solve(_ expression: String) {
        if !expression.isEmpty {
            operationQueue.addOperation {
                let (result, error) = OperationSolver.solveExpression(expression: expression)
                self.delegate?.solvedExpression(result, error)
            }
        }
    }
    
    public static func solveExpression(expression: String) -> (Double, Error?) {
        var result: Double = 0
        let newExpression = addSilentMultiplication(expression: checkNegativeNumber(expression: expression))
        do {
            if try Validator.isValid(expression: newExpression) {
                result = try evaluateExpression(expression: findOperations(expression: newExpression))
            }
        } catch let error as OperationError {
            return (0, error)
        } catch {
            return (0, error)
        }
        
        return (result, nil)
    }
    
    private static func findOperations(expression: String) throws ->  [String] {
        var stack: [String] = []
        var exit: [String] = []
        let expArray = Array(expression)
        var wasNumber = false
        for itemElement in expArray {
            let item: String = String(itemElement)
            if digits.contains(item) {
                if wasNumber {
                    exit[exit.count - 1] += item
                }
                else {
                    exit.append(item)
                }
                wasNumber = true
            } else if weakFunctions.contains(item) {
                while stack.last != nil {
                    guard let stackItem = stack.last else { fatalError("Weak function checker -- stack is empty!")}
                    if strongFunctions.contains(stackItem) {
                        exit.append(stackItem)
                        _ = stack.popLast()
                    } else if weakFunctions.contains(stackItem) {
                        exit.append(stackItem)
                        _ = stack.popLast()
                    }
                    else {
                        break
                    }
                }
                stack.append(item)
                wasNumber = false
            } else if strongFunctions.contains(item) {
                while stack.last != nil {
                    guard let stackItem = stack.last else { fatalError("Strong function checker -- stack is empty!")}
                    if strongFunctions.contains(stackItem) {
                        exit.append(stackItem)
                        _ = stack.popLast()
                    }
                    else {
                        break
                    }
                }
                stack.append(item)
                wasNumber = false
            }
            else if item == "(" {
                stack.append(item)
                wasNumber = false
            }
            else if item == ")" {
                while stack.last != "("  {
                    guard let stackItem = stack.last else { throw OperationError.invalidParenthesis }
                    exit.append(stackItem)
                    _ = stack.popLast()
                }
                _ = stack.popLast()
                wasNumber = false
            }
        }
        if !stack.isEmpty {
            for index in (0...stack.count - 1).reversed() {
                exit.append(stack[index])
            }
        }
        return exit
    }
    
    private static func evaluateExpression(expression: [String]) throws -> Double {
        var stack: [Double] = []
        for item in expression {
            if let x = Double(item) {
                stack.append(x)
            } else if weakFunctions.contains(item) || strongFunctions.contains(item) {
                guard let first = stack.popLast(),
                    let second = stack.popLast()
                    else {
                        throw OperationError.unauthorized
                }
                let value = try doOperations(a: first , b: second, operation: item)
                stack.append(value)
            }
        }
        
        return stack.reduce(0, +)
    }
    
    private static func doOperations(a: Double, b: Double, operation: String) throws -> Double {
        switch operation {
        case "+":
            return b + a
        case "-":
            return b - a
        case "*":
            return b * a
        case "/":
            guard a != 0 else {
                 throw OperationError.zeroDivisior
            }
            return b / a
        default:
            throw OperationError.unauthorized
        }
    }
    
    private static func addSilentMultiplication(expression: String) -> String {
        var newExpression: [String.Element] = Array(expression)
        var indices: [Int] = []
        
        for index in 0..<newExpression.count {
            let item = String(newExpression[index])
            
            if !(index - 1 < 0) {
                let previousItem = String(newExpression[index - 1])
                if item == "(" && digits.contains(previousItem) {
                    indices.append(index + indices.count)
                }
                else if previousItem == ")" && digits.contains(item) {
                    indices.append(index + indices.count)
                }
                else if previousItem == ")" && item == "(" {
                    indices.append(index + indices.count)
                }
            }

        }
        
        for index in indices {
            newExpression.insert("*", at: index)
        }
        
        return String(newExpression)
    }
    
    private static func checkNegativeNumber(expression: String) -> String {
        var newExpression: [String.Element] = Array(expression)
        var indices: [Int] = []
        
        for index in 0..<newExpression.count {
            let item = String(newExpression[index])
            
            if index - 1 < 0 {
                if weakFunctions.contains(item) {
                    indices.append(index + indices.count)
                }
            }
            else {
                let previousItem = String(newExpression[index - 1])
                if weakFunctions.contains(item) && !digits.contains(previousItem) && previousItem != ")" {
                    indices.append(index + indices.count)
                }
            }
        }
        
        for index in indices {
            newExpression.insert("0", at: index)
        }
        
        return String(newExpression)
    }
}
