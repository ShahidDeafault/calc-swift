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
    
    // helper function to check if token is a number
    private func isNumber(token: String) -> Bool {
        let tokenHasUnary: Bool = token.hasPrefix("-") || token.hasPrefix("+")
        
        if token.count > 1 && tokenHasUnary {
            var slicedToken: String = token
            slicedToken.removeFirst()
            return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: slicedToken))
        }
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: token))
    }
    
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
        var tokensRPN = [String]()
        
        for token in expression {
            if token == "(" {
                stack.append(token)
            }
            else if token == ")" {
                while stack.last != "(" {
                    tokensRPN.append(stack.popLast()!)
                }
                stack.removeLast()
            }
            else {
                if try validNumber(token: token) {
                    tokensRPN.append(token)
                }
                else {
                    while !stack.isEmpty && (getPrecedence(op: stack.last!) >= getPrecedence(op: token)) {
                        tokensRPN.append(stack.popLast()!)
                    }
                    stack.append(token)
                }
            }
        }
        while !stack.isEmpty {
            tokensRPN.append(stack.popLast()!)
        }
        expression = tokensRPN
    }
    
    // solve the expression
    func evaluateExpression() throws -> Int {
        var stack = [String]()
        var result: Int = 0
        
//        guard expression.count == 1 else {
//            <#statements#>
//        }
        for token in expression {
            if isNumber(token: token) {
                stack.append(token)
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
                        stack.append(String(result))
                        break
                    case "/":
                        if rhs == 0 {
                            throw CalcError.divisionByZero
                        }
                        result = lhs / rhs
                        stack.append(String(result))
                        break
                    case "%":
                        if rhs == 0 {
                            throw CalcError.divisionByZero
                        }
                        result = lhs % rhs
                        stack.append(String(result))
                        break
                    case "+":
                        result = lhs + rhs
                        stack.append(String(result))
                        break
                    case "-":
                        result = lhs - rhs
                        stack.append(String(result))
                        break
                    default:
                        break
                    }
                }
            }
        }
        
//        stack.count == 1 && try validNumber(token: stack.popLast()!) {
//            result = Int(stack.popLast()!)!
//        }
        
        return result
    }

}

