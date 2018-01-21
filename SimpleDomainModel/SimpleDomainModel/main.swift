//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    public mutating func convert(_ to: String) -> Money {
        switch currency {
        case "GBP":
            switch to {
            case "EUR":
                self.amount *= 3
            case "CAN":
                self.amount /= 4/10
            default:
                self.amount *= 2
            }
            
        case "EUR":
            switch to {
            case "GBP":
                self.amount /= 3
            case "CAN":
                self.amount /= 6/5
            default:
                self.amount /= 3/2
            }
            
        case "CAN":
            switch to {
            case "GBP":
                self.amount *= 4/10
            case "EUR":
                self.amount *= 6/5
            default:
                self.amount /= 5/4
            }
        default:
            switch to {
            case "GBP":
                self.amount /= 2
            case "EUR":
                self.amount *= 3/2
            default:
                self.amount *= 5/4
            }
        }
        self.currency = to
        return self
    }
    
    public mutating func add(_ to: Money) -> Money {
        if(self.currency != to.currency) {
            self = self.convert(to.currency)
        }
        self.amount += to.amount
        return self
    }
    public mutating func subtract(_ from: Money) -> Money {
        if(self.currency != from.currency) {
            self = self.convert(from.currency)
        }
        self.amount -= from.amount
        return self
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Hourly(let wages):
            return Int(wages) * hours
        case .Salary(let wages):
            return wages
        }
    }
    
    open func raise(_ amt : Double) {
        switch type {
        case .Hourly(let wages):
            self.type = JobType.Hourly(wages + amt)
        case .Salary(let wages):
            self.type = JobType.Salary(wages + Int(amt))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get { }
        set(value) {
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get { }
        set(value) {
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
    }
    
    open func haveChild(_ child: Person) -> Bool {
    }
    
    open func householdIncome() -> Int {
    }
}





