//
//  MealTypes.swift
//  MidtermNewModels
//
//  Created by Zoë Klapman on 11/1/21.
//

import Foundation

// conform to CaseIterable so we can get iterate and count of cases

enum MealTypes: String, CaseIterable, Comparable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
    
    static func <(lhs: Self, rhs: Self) -> Bool {
        return SortOrderForMealType(mealType: lhs) < SortOrderForMealType(mealType: rhs)
    }
    static func >(lhs: Self, rhs: Self) -> Bool {
        return SortOrderForMealType(mealType: lhs) > SortOrderForMealType(mealType: rhs)
    }
    static func <=(lhs: Self, rhs: Self) -> Bool {
        return SortOrderForMealType(mealType: lhs) <= SortOrderForMealType(mealType: rhs)
    }
    static func >=(lhs: Self, rhs: Self) -> Bool {
        return SortOrderForMealType(mealType: lhs) >= SortOrderForMealType(mealType: rhs)
    }
}

private func SortOrderForMealType(mealType: MealTypes) -> Int {
    switch mealType {
    case .breakfast:
        return 0
    case .lunch:
        return 1
    case .dinner:
        return 2
    case .snack:
        return 3
    }
}

extension CaseIterable where Self: Equatable {
    // derived value to find the index of enum
    var index: Self.AllCases.Index? {
        return Self.allCases.firstIndex(where: { self == $0 })
    }
    
    // given the index, return the enum type
    static func element(at index: Int) -> MealTypes? {
        let elements = MealTypes.AllCases()
        
        return (0...elements.count).contains(index) ? elements[index] : nil
        // return (Int.random(in: 0..<elements.count)).contains(index) ? elements[index] : nil        // get 0 to 4
    }
}
