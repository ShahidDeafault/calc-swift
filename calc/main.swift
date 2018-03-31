//
//  main.swift
//  calc
//
//  Created by Jesse Clark on 12/3/18.
//  Copyright © 2018 UTS. All rights reserved.
//

import Foundation

var args = ProcessInfo.processInfo.arguments
args.removeFirst() // remove the name of the program (the executable name "./calc")

var expression = Expression(expression: args)
let result: Int

do {
    try expression.convertToPostfix()
    try result = expression.evaluateExpression()
    
    print(result)
}
catch let error as CalcError {
    switch error {
    case .insufficientTerms:
        print("Incomplete expression. Expected input of the form [number operator number ...]")
        exit(1)
    case .invalidInput(let input):
        print("Invalid input: \(input)")
        exit(2)
    case .divisionByZero:
        print("Division by zero")
        exit(3)
    case .integerOutOfBound(let number):
        print("Invalid number: \(number) (integer out-of-bounds)")
        exit(4)
    }
    
}
