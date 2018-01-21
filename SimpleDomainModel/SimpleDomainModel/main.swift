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
        get {
            let title = _job?.title
            let type = _job?.type
            return Job(title: title!, type: type!)
        }
        set(value) {
            _job = Job(title: (value?.title)!, type: (value?.type)!)
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            let firstName = _spouse?.firstName
            let lastName = _spouse?.lastName
            let age = _spouse?.age
            return Person(firstName: firstName!, lastName: lastName!, age: age!)
        }
        set(value) {
            _spouse = Person(firstName: (value?.firstName)!, lastName: (value?.lastName)!, age: (value?.age)!)
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job?.title ?? "nil") spouse:\(spouse?.firstName ?? "nil") \(spouse?.lastName ?? "nil")]"
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
            income += (members[num].job?.calculateIncome(2000))!
        }
        return income
    }
}





