//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

var args = ProcessInfo.processInfo.arguments
args.removeFirst() // remove the name of the program


//for item in args {
//    print(item)
//}
print(Int(args[0])!)
print(args[1])
print(args[2])

//var expression: Expression = Expression(expression: args)

private func isNumber(tokens: String) -> Bool {
    return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: tokens))
}

// helper function to check if token is an operator
private func isOperator(tokens: String) -> Bool {
    switch tokens {
    case "*", "/", "%", "+", "-":
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
    if op == "*" || op == "/" || op == "%" {
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
            if isNumber(tokens: token) {
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

print(convertToPostfix())






//do {
//    let input: String
//
//    var expression = Expression(expression: args);
////    try? Expression.solve();
//}
//catch CalcError.invalidInput {
//    print("Invalid input")
//    exit(1)
//}
//catch CalcError.divisionByZero {
//    print("Division by zero")
//    exit(2)
//}
//catch CalcError.integerOutOfBound {
//    print("Invalid number - integer out-of-bounds")
//    exit(3)
//}

