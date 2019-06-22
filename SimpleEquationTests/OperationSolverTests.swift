//
//  OperationSolverTests.swift
//  SimpleEquationTests
//
//  Created by Przemysław Kalawski on 22/06/2019.
//  Copyright © 2019 Przemysław Kalawski. All rights reserved.
//

import XCTest

@testable import SimpleEquation
class OperationSolverTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSolveOperation() {
        let expressions: [(String, Double)] = [("3*(5+7)-15", 21 ), ("+1", 1), ("-(-1)", 1), ("()", 0), ("(-1)-1", -2), ("1+3*(4+2*3)", 31), ("3*(9-2*4+1)-2", 4), ("((2+5)-(3-1))*3+4", 19), ("(2)3", 6), ("23(-1)", -23), ("20(-1)(-1)(-1)1", -20)]
        
        expressions.forEach { (arg) in
            let (expression, result): (String, Double) = arg
            XCTAssertEqual(OperationSolver.solveExpression(expression: expression).0, result, "Score computed is wrong!")
        }
    }
}
