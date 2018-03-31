//
//  Expression.swift
//  calc
//
//  Created by Audwin on 24/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

struct Expression {
    var expression: [String]
    
    /// helper function to check if token is a number
    private func isNumber(token: String) -> Bool {
        let tokenHasUnary: Bool = token.hasPrefix("-") || token.hasPrefix("+")
        var checkedToken: String = token
        
        if checkedToken.count > 1 && tokenHasUnary {
            checkedToken.removeFirst()
        }
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: checkedToken))
    }
    
    /// helper function to check if token is valid within the integer range
    private func validNumber(token: String) throws -> Bool {
        if isNumber(token: token) && Int(token) == nil {
            throw CalcError.integerOutOfBound(number: token)
        }
        return Int(token) != nil
    }
    
    // helper function to check if token is an operator
    private func isOperator(token: String) -> Bool {
        switch token {
        case "x", "/", "%", "+", "-":
            return true
        default:
            return false
        }
    }
    
    // get the operator precedence
    private func getPrecedence(op: String) -> Int {
        if op == "(" {
            return 0
        }
        if op == "+" || op == "-" {
            return 1
        }
        if op == "x" || op == "/" || op == "%" {
            return 2
        }
        return 3;
    }
    
    // shunting-yard algorithm
    mutating func convertToPostfix() throws {
        var stack = [String]()
        var output = [String]()

        if expression.count < 3 && !isNumber(token: expression.last!) {
            throw CalcError.insufficientTerms
        }
        
        for token in expression {
            if token == "(" {
                stack.append(token)
            }
            else if token == ")" {
                while stack.last != "(" {
                    output.append(stack.popLast()!)
                }
            }
            else {
                if try validNumber(token: token) {
                    output.append(token)
                }
                else {
                    while !stack.isEmpty && (getPrecedence(op: stack.last!) >= getPrecedence(op: token)) {
                        output.append(stack.popLast()!)
                    }
                    stack.append(token)
                }
            }
        }
        while !stack.isEmpty {
            output.append(stack.popLast()!)
        }
        expression = output
    }
    
    // solve the expression
    func evaluateExpression() throws -> Int {
        var stack = [String]()
        var result: Int = 0
        
        for token in expression {
            if try validNumber(token: token) {
                stack.append(token)

                if (expression.count == 1) {
                    result = Int(stack.first!)!
                }
            }
            // token is an operator
            else {
                guard isOperator(token: token) else {
                    throw CalcError.invalidInput(input: token)
                }
                if (stack.count > 1) {
                    let rhs: Int = Int(stack.popLast()!)!
                    let lhs: Int = Int(stack.popLast()!)!

                    switch token {
                    case "x":
                        result = lhs * rhs
                    case "/":
                        if rhs == 0 {
                            throw CalcError.divisionByZero
                        }
                        result = lhs / rhs
                    case "%":
                        if rhs == 0 {
                            throw CalcError.divisionByZero
                        }
                        result = lhs % rhs
                    case "+":
                        result = lhs + rhs
                    case "-":
                        result = lhs - rhs
                    default:
                        break
                    }
                    stack.append(String(result))
                }
            }
        }
        return result
    }

}

