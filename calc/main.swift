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


//for item in args {
//    print(item)
//}
//print(Int(args[0])!)
//print(args[1])
//print(args[2])

var expression: Expression = Expression(expression: args)
let result: Int

do {
    try expression.convertToPostfix()
    try result = expression.evaluateExpression()
    
    print(result)
}
catch let error as CalcError {
    switch error {
    case .invalidInput:
        print("Invalid input")
        exit(1)
    case .divisionByZero:
        print("Division by zero")
        exit(2)
    case .integerOutOfBound:
        print("Invalid number - integer out-of-bounds")
        exit(3)
    }
    
    
    
    
}
