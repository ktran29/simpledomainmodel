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
    
    public func convert(_ to: String) -> Money {
        
        var convertedAmount = 0
        
        switch currency {
        case "GBP":
            switch to {
            case "EUR":
                convertedAmount = self.amount * 3
            case "CAN":
                convertedAmount = Int(Double(self.amount) * 0.4)
            default:
                convertedAmount = self.amount * 2
            }
            
        case "EUR":
            switch to {
            case "GBP":
                convertedAmount = self.amount / 3
            case "CAN":
                convertedAmount = Int(Double(self.amount) / 1.2)
            default:
                convertedAmount = Int(Double(self.amount) / 1.5)
            }
            
        case "CAN":
            switch to {
            case "GBP":
                convertedAmount = Int(Double(self.amount) * 0.4)
            case "EUR":
                convertedAmount = Int(Double(self.amount) * 1.2)
            default:
                convertedAmount = Int(Double(self.amount) / 1.25)
            }
        default:
            switch to {
            case "GBP":
                convertedAmount = self.amount / 2
            case "EUR":
                convertedAmount = Int(Double(self.amount) * 1.5)
            default:
                convertedAmount = Int(Double(self.amount) * 1.25)
            }
        }
        return Money(amount: convertedAmount, currency: to)
    }
    
    public func add(_ to: Money) -> Money {
        var newMoney = Money(amount: self.amount, currency: self.currency)
        if(self.currency != to.currency) {
            newMoney = newMoney.convert(to.currency)
        }
        newMoney.amount += to.amount
        return newMoney
    }
    public func subtract(_ from: Money) -> Money {
        var newMoney = Money(amount: self.amount, currency: self.currency)
        if(self.currency != from.currency) {
            newMoney = newMoney.convert(from.currency)
        }
        newMoney.amount -= from.amount
        return newMoney
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
            return Int(wages * Double(hours))
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
        get {
            return _job
        }
        set(value) {
            if value != nil {
                _job = self.age >= 18 ? Job(title: value!.title, type: value!.type) : nil
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return _spouse
        }
        set(value) {
            if value != nil {
                _spouse = value!.age >= 18 && self.age >= 18 ? Person(firstName: value!.firstName, lastName: value!.lastName, age: value!.age) : nil
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        
        var spouseName = "nil"
        var jobName = "nil"
        
        if _spouse != nil {
            spouseName = "\(_spouse!.firstName) \(_spouse!.lastName)"
        }
        
        if _job != nil {
            jobName = "\(_job!.title)"
        }
        
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(jobName) spouse:\(spouseName)]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
    }
    
    open func haveChild(_ child: Person) -> Bool {
        if members[0].age >= 21 || members[1].age >= 21 {
            members.append(child)
            return true
        }
        return false
    }
    
    open func householdIncome() -> Int {
        var income = 0
        for num in 0...members.count - 1 {
            let job = members[num].job
            if job != nil {
                income += job!.calculateIncome(2000)
            }
        }
        return income
    }
}





