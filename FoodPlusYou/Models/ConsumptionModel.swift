//
//  ConsumptionModel.swift
//  MidtermNewModels
//
//  Created by Zoë Klapman on 11/1/21.
//

import Foundation

struct Goals {
    var goal: FoodItemsDetails = FoodItemsDetails(food_name: "", brand_name: "", photo: PhotoUrl(thumb: ""), nf_calories: 0.0, nf_total_carbohydrate: 0.0, nf_total_fat: 0.0, nf_protein: 0.0)
}

struct MealItem: Equatable {
    var id = UUID().uuidString
    var foodItem: FoodItemsDetails
    var servings: Int = 1
    var adjustedMacros: FoodItemsDetails = FoodItemsDetails(food_name: "", brand_name: "", photo: PhotoUrl(thumb: ""), nf_calories: 0.0, nf_total_carbohydrate: 0.0, nf_total_fat: 0.0, nf_protein: 0.0)
    
    init(foodItem: FoodItemsDetails, servings: Int) {
        self.foodItem = foodItem
        self.servings = servings
    }
    
    static func ==(lhs: MealItem, rhs: MealItem) -> Bool {
        return lhs.id == rhs.id
    }
}

struct MealList {
    var items: [MealItem] = []
    var totalMacros: FoodItemsDetails = FoodItemsDetails(food_name: "", brand_name: "", photo: PhotoUrl(thumb: ""), nf_calories: 0.0, nf_total_carbohydrate: 0.0, nf_total_fat: 0.0, nf_protein: 0.0)
}

struct DailyConsumption {
    var mealList: [MealTypes : MealList] = [:]
    var totalMacros: FoodItemsDetails = FoodItemsDetails(food_name: "", brand_name: "", photo: PhotoUrl(thumb: ""), nf_calories: 0.0, nf_total_carbohydrate: 0.0, nf_total_fat: 0.0, nf_protein: 0.0)
}

class ConsumptionModel {
    var myDailyTarget: Goals
    var myDailyMeals: [String : DailyConsumption] = [:]
    
    static let sharedInstance = ConsumptionModel()
    
    init() {
        myDailyTarget = Goals(goal: FoodItemsDetails(food_name: "", brand_name: "", photo: PhotoUrl(thumb: ""), nf_calories: 0.0, nf_total_carbohydrate: 0.0, nf_total_fat: 0.0, nf_protein: 0.0))
        
    }
    
    func setMyTarget(goal: FoodItemsDetails) {
        myDailyTarget.goal.nf_calories = goal.nf_calories
        myDailyTarget.goal.nf_total_carbohydrate = goal.nf_total_carbohydrate
        myDailyTarget.goal.nf_total_fat = goal.nf_total_fat
        myDailyTarget.goal.nf_protein = goal.nf_protein
    }
    
    func getGoal() -> FoodItemsDetails? {
        return myDailyTarget.goal
    }
    
    func getDaysMacroTotals(forDate date: String) -> FoodItemsDetails? {
        return myDailyMeals[date]?.totalMacros
    }
    
    func getMealMacroTotals(forDate date: String, forMeal type: MealTypes) -> FoodItemsDetails? {
        return myDailyMeals[date]?.mealList[type]?.totalMacros
    }
    
    func getMealList(forDate date: String, forMeal type: MealTypes) -> MealList? {
        return myDailyMeals[date]?.mealList[type]
    }
    
    func addDailyConsumption(forDate date: Date) {
        let dateKey = date.asYearMonthDay(forDate: date)
        myDailyMeals[dateKey] = DailyConsumption()
    }
    
    func addMealItem(foodItem item: FoodItemsDetails, numServings servings: Int) -> MealItem {
        var mealItem: MealItem = MealItem(foodItem: item, servings: servings)
        
        mealItem.adjustedMacros.food_name = mealItem.foodItem.food_name + " (\(servings))"
        mealItem.adjustedMacros.nf_calories = mealItem.foodItem.nf_calories * Double(servings)
        mealItem.adjustedMacros.nf_total_carbohydrate = mealItem.foodItem.nf_total_carbohydrate * Double(servings)
        mealItem.adjustedMacros.nf_total_fat = mealItem.foodItem.nf_total_fat * Double(servings)
        mealItem.adjustedMacros.nf_protein = mealItem.foodItem.nf_protein * Double(servings)
        
        return mealItem
    }
    
    func addFoodItemToMeal(forDate date: String, mealItem item: MealItem, forMeal type: MealTypes) {
        if(myDailyMeals[date]?.mealList[type] == nil) {
            myDailyMeals[date]?.mealList[type] = MealList()
        }
        myDailyMeals[date]!.mealList[type]!.items.append(item)
        
        // update meal list's macros
        myDailyMeals[date]!.mealList[type]!.totalMacros.nf_calories = item.adjustedMacros.nf_calories + myDailyMeals[date]!.mealList[type]!.totalMacros.nf_calories
        myDailyMeals[date]!.mealList[type]!.totalMacros.nf_total_carbohydrate = item.adjustedMacros.nf_total_carbohydrate + myDailyMeals[date]!.mealList[type]!.totalMacros.nf_total_carbohydrate
        myDailyMeals[date]!.mealList[type]!.totalMacros.nf_total_fat = item.adjustedMacros.nf_total_fat + myDailyMeals[date]!.mealList[type]!.totalMacros.nf_total_fat
        myDailyMeals[date]!.mealList[type]!.totalMacros.nf_protein = item.adjustedMacros.nf_protein + myDailyMeals[date]!.mealList[type]!.totalMacros.nf_protein
        
        // update day's macros
        myDailyMeals[date]!.totalMacros.nf_calories = item.foodItem.nf_calories + myDailyMeals[date]!.totalMacros.nf_calories
        myDailyMeals[date]!.totalMacros.nf_total_carbohydrate = item.foodItem.nf_total_carbohydrate + myDailyMeals[date]!.totalMacros.nf_total_carbohydrate
        myDailyMeals[date]!.totalMacros.nf_total_fat = item.foodItem.nf_total_fat + myDailyMeals[date]!.totalMacros.nf_total_fat
        myDailyMeals[date]!.totalMacros.nf_protein = item.foodItem.nf_protein + myDailyMeals[date]!.totalMacros.nf_protein
    }
    
    func removeFoodItemFromMeal(forDate date: String, mealItem itemIndex: Int, forMeal type: MealTypes) {
        let item = myDailyMeals[date]!.mealList[type]!.items[itemIndex]
        myDailyMeals[date]!.mealList[type]!.totalMacros.nf_calories = myDailyMeals[date]!.mealList[type]!.totalMacros.nf_calories - item.adjustedMacros.nf_calories
        myDailyMeals[date]!.mealList[type]!.totalMacros.nf_total_carbohydrate = myDailyMeals[date]!.mealList[type]!.totalMacros.nf_total_carbohydrate - item.adjustedMacros.nf_total_carbohydrate
        myDailyMeals[date]!.mealList[type]!.totalMacros.nf_total_fat = myDailyMeals[date]!.mealList[type]!.totalMacros.nf_total_fat - item.adjustedMacros.nf_total_fat
        myDailyMeals[date]!.mealList[type]!.totalMacros.nf_protein = myDailyMeals[date]!.mealList[type]!.totalMacros.nf_protein - item.adjustedMacros.nf_protein
        
        myDailyMeals[date]!.totalMacros.nf_calories = myDailyMeals[date]!.totalMacros.nf_calories - item.foodItem.nf_calories
        myDailyMeals[date]!.totalMacros.nf_total_carbohydrate = myDailyMeals[date]!.totalMacros.nf_total_carbohydrate - item.foodItem.nf_total_carbohydrate
        myDailyMeals[date]!.totalMacros.nf_total_fat = myDailyMeals[date]!.totalMacros.nf_total_fat - item.foodItem.nf_total_fat
        myDailyMeals[date]!.totalMacros.nf_protein = myDailyMeals[date]!.totalMacros.nf_protein - item.foodItem.nf_protein
        
        myDailyMeals[date]!.mealList[type]?.items.remove(at: itemIndex)
    }
}

extension Date {
    func asUnixTimeStampLocalTime() -> (String, String) {
        let dt = Date()
        let t = String(Int(dt.timeIntervalSince1970 * 1000))
        let formatter = DateFormatter()
        formatter.dateStyle  = .full
        formatter.timeStyle = .long
        let localTime = formatter.string(from: dt)
        return (t, localTime)
    }
    
    func currentDate() -> String {
        let dt = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        let localTime = formatter.string(from: dt)
        return localTime
    }
    
    func asYearMonthDay(forDate date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMDD"
        return formatter.string(from: date)
    }
    
    static func randomBetween(start: String, end: String, format: String = "YYYYMMDD") -> Date {
        let date1 = Date.parse(start, format: format)
        let date2 = Date.parse(end, format: format)
        return Date.randomBetween(start: date1, end: date2)
    }
    
    static func randomBetween(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }
    
    func dateString(_ format: String = "YYYYMMDD") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    static func parse(_ string: String, format: String = "YYYYMMDD") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: string)!
        return date
    }
}
