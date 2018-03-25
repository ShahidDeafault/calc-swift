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
    
    //
    private func convertToPostfix() -> [String] {
        var stack = [String]()
        var tokensRPN = [String]()
        
        for token in args {
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
        return tokensRPN
    }
}

