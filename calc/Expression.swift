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
    
//    init(expression: [String]) throws {
//
//    }
    
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
    mutating func convertToPostfix() {
        var stack = [String]()
        var tokensRPN = [String]()
        
        for token in expression {
            if token == "(" {
                stack.append(token)
            }
            else if token == ")" {
                while stack.last != "(" {
                    tokensRPN.append(stack.last!)
                    stack.removeLast();
                }
                stack.removeLast();
            }
            else {
                if isNumber(token: token) {
                    tokensRPN.append(token)
                }
                else {
                    
                    while !stack.isEmpty && (getPrecedence(op: stack.last!) >= getPrecedence(op: token)) {
                        tokensRPN.append(stack.last!)
                        stack.removeLast()
                    }
                    stack.append(token)
                }
            }
        }
        while !stack.isEmpty {
            tokensRPN.append(stack.last!)
            stack.removeLast()
        }
        expression = tokensRPN
    }
    
    func calculateExpression()  -> Int {
        var stack = [String]()
        var result: Int = 0
        
        for token in expression {
            if isNumber(token: token) {
                stack.append(token)
                
                if (stack.count == 1) {
                    result = Int(stack[0])!
                }
            }
            // token is an operator
            else {
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
                            print("Division by zeroo")
                        }
                        result = lhs / rhs
                        stack.append(String(result))
                        break
                    case "%":
                        if rhs == 0 {
                            print("Division by zeroo")
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
        return result
    }
}

